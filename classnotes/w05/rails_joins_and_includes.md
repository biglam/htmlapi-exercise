# Advanced Finders - Joins & Include

ActiveRecord provides a finder method called 'joins' for specifying JOIN clauses on the resulting SQL. There are multiple ways to use the joins method, so we'll explore some of them, and see if we can generate the same SQL

```
  show 1-----* showings *-----* user
```


## Reminder of the Basics of Finders

The simple SQL statements become trivial with ActiveRecord

```
  # Homework question
  1. Select the names of all users.
  SELECT name FROM users;
  # Rails way
  User.pluck(:name)

  # Homework question
  5. Select the price of the least expensive show.
  SELECT min(price) FROM shows;
  # Rails way
  Show.minimum(:price)

  # Homework question
  7. Select the sum of the price of all shows whose prices is less than £20.
  SELECT sum(price) FROM shows WHERE price < 20;
  # Rails way
  Show.where("price < ?", 20).sum(:price)
  # or
  Show.where(price: -Float::INFINITY...20).sum(:price)
```

But then we get to the trickier statements; the ones that the "SQL" way was to use a "JOIN" clause.


## Using a string SQL Fragment

You can manually supply the raw SQL specifying the JOIN clause to the `.joins` method.

```
  # Homework question
  10. Select the time for the Edinburgh Royal Tattoo.
  SELECT time FROM showings t JOIN shows s ON t.show_id = s.id WHERE s.name = 'Edinburgh Royal Tattoo';
  # Rails way
  Showing.joins('JOIN shows ON showings.show_id = shows.id').where(shows: {name: 'Edinburgh Royal Tattoo'}).pluck(:time)
```


## Using Array/Hash of Named Associations

But we said we'd prefer not to write SQL if we can help it; and instead, we want to let Rails do it for us.

ActiveRecord lets you use the names of the associations defined on the model as a shortcut for specifying JOIN clause for those associations when using the joins method.

- note: This method only generates INNER JOIN joins - if you want outer joins, you **have** to write your own SQL.


### Joining a Single Association

To use association names in the `.joins` method to solve the previous example, the syntax is pretty straighforward.

```
  # Rails way
  Showing.joins(:show).where(shows: {name: 'Edinburgh Royal Tattoo'}).pluck(:time)
```

And for futher questions are solved similarly, and Rails will build the joins to go through join-table too.

```
  # Homework question
  15. SELECT all users who are going to a show at 17:15.
  SELECT u.name FROM users u JOIN showings_users su ON u.id = su.user_id JOIN showings s ON su.showing_id = s.id WHERE s.time = '17:15';
  # Rails way
  User.joins(:showings).where(showings: {time: '17:15'} )
```

Remember, you can *only* do inner joins.

```
  # Homework question
  14. Select all of the user names and the count of shows they're going to see.
  SELECT u.name, count(su.show_id) FROM users u JOIN showings_users su ON su.user_id = u.id GROUP BY u.id;
  # Rails way
  User.joins(:showings).group(:id).pluck(:name, 'count(showings_users.showing_id) as show_count')
```

But do you recall; that answer misses out any users that are not attending any shows. To include the missing user, you need to go back to a SQL snippet in the join.

```
  # Rails way
  User.joins('LEFT JOIN showings_users ON showings_users.user_id = users.id').group(:id).pluck(:name, 'count(showings_users.showing_id) as show_count')
```


### Joining Multiple Associations

Once we start joining tables together in our queries, it's hard to stop. And it's so easy, that there's little reason to not keep chaining them.

If you wish to join to multiple associations, you can pass them in as an array.

```
  # what time is Michael going to see 'Le Haggis'?
  Showing.joins([:show, :users]).where(shows: { name: 'Le Haggis' }, users: { name: 'Michael Pavling' }).pluck(:time)
```


### Joining Nested Associations

```
  # Homework question
  13. Select the number of users who want to see "Shitfaced Shakespeare".
  SELECT count(su.user_id) FROM showings_users su JOIN showings s ON su.showing_id = s.id JOIN shows ON s.show_id = shows.id WHERE shows.name = 'Shitfaced Shakespeare'");
  # Rails way
  User.joins(showings: :show).where(shows: {name: 'Shitfaced Shakespeare'}).count
```

The syntax for joins supports continuing to nest and join to multiple further associations, by definition in the options.

```
  # for example, on a blog-posting app, you might do something like this
  Category.joins(posts: [{comments: :guest}, :tags])
```


## "includes" - Eager Loading Associations

Eager loading is the mechanism for loading the associated records of the objects returned by Model.find using as few queries as possible.


### N + 1 queries problem

Consider the following code, which finds 10 comments and prints their writer's name:

```
  showings = Showing.limit(10)
  showings.each do |showing|
    puts showing.show.name
  end
```

This code looks fine at the first sight. But the problem lies within the total number of queries executed. The above code executes 1 ( to find 10 showings ) + 10 ( one per each showing to load the show ) = 11 queries in total.


### Solution to N + 1 queries problem

Active Record lets you specify in advance all the associations that are going to be loaded. This is possible by specifying the includes method of the Model.find call. With includes, Active Record ensures that all of the specified associations are loaded using the minimum possible number of queries.

Revisiting the above case, we could rewrite it to 'eager load' guests:

```
  showings = Showing.includes(:show).limit(10)
  showings.each do |showing|
    puts showing.show.name
  end
```

The above code will execute just 2 queries, as opposed to 11 queries in the previous case:


## Eager Loading Multiple Associations

Active Record lets you eager load any number of associations with a single Model.find call by using an array, hash, or a nested hash of array/hash with the includes method.


### Array of Multiple Associations

This loads all the posts and the associated category and comments for each post.

```
  Showing.includes(:show, :users)
```


