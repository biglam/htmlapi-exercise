View helpers
============

We've seen that Rails already extends Ruby. One way it does this is by including a component called **Active Support** which offers us a lot more "helpful" functionality in the form of additional methods which we can access in additon to the Ruby basic ones.

## Action View
- [Link to docs](http://guides.rubyonrails.org/action_view_overview.html)

Web requests in Rails are handled by another component called **Action Pack**, which splits the work into two main parts:

1. **Action Controller**: which performs the logic.
2. **Action View**: which renders a template to HTML.

(Typically, **Action Controller** will be concerned with communicating with the database and performing CRUD actions where necessary. **Action View** is then responsible for compiling the response).

## View helpers

Action View, contains helpful methods which we can use called **view helpers** which are generally designed to make our life easier. They simplify common tasks done in our view files when they are rendered to HTML. They:

  - **Generate HTML elements**
  - **Standardise display**

This is only a brief overview summary of the helpers available in Action View. It's recommended that you review the [API Documentation](http://api.rubyonrails.org/classes/ActionView/Helpers.html), which covers all of the helpers in more detail.

# Let's have a look

We have built a chicken management app.

[GitHub Link to Chicken App](https://github.com/codeclan/cx3_curriculum/tree/master/rails_view_helpers/rails_helpers/val_app_before)

Students should clone the repo, then:

```
bundle install
rake db:create
rake db:migrate
rails s
```
Brief talk through the app, in particular the controller and schema.

# Creating a new chicken

If we look at our chicken views new.html.erb we can see a form very similar to the ones we created using Sinatra. We can see the form tag, the method type and the action as well as all the inputs.

This is perfectly valid HTML and the rendered page will function - create a new chicken.

However, Rails is super nice to us and provide view helpers to make our lives much easier and avoid us having to manually create these forms.

Let's delete our current form.

Now let's create this form again using Rails helpers.

We have a @chicken object that's being passed from the controller. Now we want to create a new chicken form, and can do so by:

```
<%= form_for @chicken do |f|%>

<% end %>
```

@chicken is the actual object being created/edited.

The form_for method yields a form builder object (the f variable) and methods to create form controls are called on the form builder object f.

# Basic form helpers
Rails provides many basic form helpers to generate HTML for us including inputs, radio buttons and so on. Let's use a few of these on our form.

```
  <%= f.label :name %>
  <%= f.text_field :name %>
  <br>
  <br>
  <%= f.label :colour, 'Feather color' %>
  <%= f.color_field :colour %>
  <br>
  <br>
  <%= f.label :age %>
  <%= f.number_field :age %>
  <br>
  <br>
  <%= f.label :favourite %>
  <%= f.check_box :favourite %>
  <br>
  <br>
  <%= f.label :birthday %>
  <%= f.date_field :birthday %>
  <br>
  <br>
  <%= f.label :weight %>
  <%= f.number_field :weight, min: 1000, max: 2000, step: 5 %>
  <br>
  <br>
  <%= f.label :rating %>
  <%= f.range_field :rating, min: 1, max: 10 %>
  <br>
  <br>
  <%= f.label :imageurl %>
  <%= f.text_field :imageurl %>
  <br>
  <br>
  <%= f.label :gender %>
  <%= f.select :gender, "<option>Male</option><option>Female</option>".html_safe %>
  <br>
  <br>
  <%= f.submit "create chicken" %>
```

One at a time build and view the form.

note: many of the form helpers can take options, like we have utilised. The number_field can take a min, max and a step.

# Index (tony)

## Show route (show.html.erb)

# Date helpers
Let's display our chickens and use some more Rails helpers in our show route.

In the show.html.erb lets add:

```
  <h1><%= @chicken.name %></h1>
  <p>Last updated <%= time_ago_in_words(@chicken.updated_at) %></p>
  <b>Chicken was born:</b>
  <p><%= time_ago_in_words(@chicken.birthday) %> ago</p>
```

# Number helpers

```
  <b>All chickens live for 100 days only, percentage through visit to farm:</b>
  <p><%= number_to_percentage(@chicken.age, precision: 0) %></p>

  <b>Chicken weight:</b>
  <p><%= number_to_human(@chicken.weight) %></p>
```

# Image helper

```
  <b>Pic of this chicken</b>
  <p><%= image_tag(@chicken.imageurl) %></p>
```

## Resources
- [http://guides.rubyonrails.org/action_view_overview.html](http://guides.rubyonrails.org/action_view_overview.html)
- [http://api.rubyonrails.org/classes/ActionView/Helpers.html](http://api.rubyonrails.org/classes/ActionView/Helpers.html)
- [http://apidock.com/rails/ActionView/Helpers/](http://apidock.com/rails/ActionView/Helpers/)


