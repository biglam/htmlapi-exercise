# Scopes


A scope is a subset of a collection. Sounds complicated? It isn't really. Imagine this:

You have Users. Now, some of those Users are subscribed to your newsletter. You marked those who receive a newsletter by adding a field to the Users Database (user.subscribed_to_newsletter = true). Naturally, you sometimes want to get those Users who are subscribed to your newsletter.

You could do this with an ActiveRecord finder.

```
  User.where(subscribed_to_newsletter: true).each do |user|
    # do stuff
  end
```

But everywhere you want to work with the subscribers, you need to write that finder; and what happens if either the definition of what a subscribed User is changes, or if it's just much more complicated in the first place.

Using finders like this is not very DRY or re-useable.

A Rails 'scope' is kindof like a way of making a single place to define a finder like this, and then being able to re-use it easily.


## Scope practice

We're going to try out using scopes in a blog-posting app.

```
  category 1-----* post 1-----* comment
                    1              1
                    |              |
                    |              |
                    *              1
                   tag           guest
```

The app tracks blog `Post` objects, each of which belongs to a `Category`, and can have many `Tag`s and many `Comments`. Each `Comment` is associated to a `Guest`.


## First scope

If we want limit the scope of posts we get back from an ActiveRecord query to just those which are published, we could write a scope which returns only those records which have a value in the `published_at` field.

```
  # app/models/post.rb
  scope :published, -> { where('posts.published_at is not null') }
```

And call it as a class method.

```
  # rails console
  Post.published
```

We can chain all/any other ActiveRecord query methods to the result of a scope, because scopes return an `ActiveRecord::Relation` object.

```
  # rails console
  Post.published.where(published_at: Date.today..Date.tomorrow)

  Post.published.joins(:comments).group('comments.post_id').having('count(comments.post_id) > 14')
```

And we can do the same inside scopes, so we could return only those posts which have been commented on:

```
  # app/models/post.rb
  scope :commented, -> { joins(:comments).group('comments.post_id').having('count(comments.post_id) > 0') }
```

Because we can't possibly know what other joins will be performed on our scopes in future, we have to ensure that all field names are unambiguous in the SQL:

```
  # AVOID SCOPES LIKE THIS, WHICH HAVE POTENTIALLY AMBIGUOUS COLUMN NAMES
  scope :published, -> { where('published_at is not null') } # the Comment model has a `published_at` column too, so this will break if it's ever joined to comments
```


## Digging into scopes

We can also chain our scopes together to re-use querying functionality:

```
  # rails console
  Post.published.commented
```

Additionally, we can use scopes inside scopes to DRY up further (hough it's more useful when you can think of a shorter name to give the combined scopes:

```
  # app/models/post.rb
  scope :published_and_commented, -> { published.commented }
```

And as well as being class-level methods, our scopes are available on associations:

```
  # rails console
  Category.first.posts.published
```


## Working with times

Remember: Dates and Times are going to be the bane of our lives...

If you're working with dates or times within scopes, due to how Rails evaluates scopes, you will __need__ to use a lambda.

Indeed, this was such a stumbling point for so many people, Rails now forces you to use a lambda for every scope definition.

```
  # app/models/post.rb
  scope :in_the_last_week, -> { where("posts.published_at > ?", Time.zone.now.ago(1.week) ) }
```

Note: Without the lambda, prior to Rails 4, the above `Time.zone.now` will only be called once in production environment, and Rails will remember and re-use the time as it was the first time it was run. As time goes by, you end up with the wrong records, as the Time drifts further into the past... generally without you noticing for some time.

```
  # erroneous syntax for example - **DO NOT WRITE SCOPES WITH DATES/TIMES IN LIKE THIS**
  scope :in_the_last_week, where("published_at > ?", Time.zone.now.ago(1.week) )
```


## Lambdas

Because a lambda is used for a scope, you can pass it arguments to make your scopes even more flexible.

```
  # app/models/post.rb
  scope :one_week_before, -> (time) { where(published_at: (time.ago(1.week)..time)) }

  # rails console
  Post.one_week_before(Time.zone.now)
```

However, this is just duplicating the functionality that would be provided to you by the syntax of writing a class method like this.

```
  # app/models/post.rb
  def self.one_week_before(time)
    where(published_at: (time.ago(1.week)..time))
  end
```

Either syntax is acceptable, but the class method is preferred for complicated (multi-line) conditions, or if you need to add any conditional logic.

Just ensure the method always returns an `ActiveRecord::Relation` so that it can be chained to other scopes and methods.

```
  # rails console
  Category.first.posts.one_week_before(Time.zone.now) # both the scope and the class method are accessed the same way
```


# Default Scopes

You can set a "default_scope" for a class, to extend the functionality of the `.all` method:

```
  # app/models/post.rb
  default_scope -> { published.order(:published_at).reverse_order }
```

You can remove all scopes with `.unscoped` - particularly for when you need to remove/override a default_scope.

However, changing the default scope is often confusing and surprising for other developers, and can lead to funny results in your queries. So best to not use it if possible.

