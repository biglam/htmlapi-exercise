# Rails Migrations

Migrations are a way for us to manage the creation and alteration of our database tables in a structured and organized manner.

Each migration is a seperate file, which Rails runs for us when we instruct it. Rails keeps track of what's been run, so changes don't get attempted more than once.

We describe the DB changes using Ruby, and it doesn't matter which DB engine we use - Rails has connectors for each different DB engine we might use, which translates the ruby structure into the appropriate DB commands.

[http://guides.rubyonrails.org/v4.2.4/migrations.html]()


# Starting with migrations

We need an application to work with our migrations in. We shall imagine that this application is going to be an online-shop, which will display lists of products for customers to buy.

Note: The nouns in the description of our app give us a good initial idea of what models we might need to work with.

```
  # terminal
  rails new migrations_app # without specifying a DB, Rails will default to using SQLite3)
  cd migrations_app
```

Let's create a migration called "CreateProducts", which will have the job of creating the products table in our database.

```
  # terminal
  rails generate migration CreateProducts
```

Note: This is our first real contact with Rails' "generators" -- there is a large section of Rails dedicated to doing the boiler-plate for you. It's too easy to let the generators do *all* the work, and rely on them wholly. We want to be pragmatic, and use them to help us be lazy; to do the repetative stuff for us, so we can get on with focussing on the interesting detail, but we will always check that what they did was what we wanted.

Another note: If you make a mistake in the generate command, you can reverse it with `rails destroy migration CreateProducts`

That command will have created a migration file in our `RAILS_ROOT/db/migrate` folder. The purpose of this file is to describe what actions we want to take to move our DB schema from its current state to the new state, and also, what would need to happen to move the migration back to the old state again (should we need to).

Add content to the 'change' method.

```
  class CreateProducts < ActiveRecord::Migration
    def change
      create_table :products do |t|
        t.string :name
        t.text :description

        t.timestamps
      end
    end
  end
```

We run migrations with the command `rake db:migrate`

Note: This is another new feature: "[Rake](https://github.com/ruby/rake)" is a tool for managing scripts that we may write or use to automate repetative command-line tasks - like looking at lots of migration files to determine which to run to move a database from one state to another (you don't want to have a migration run more that once on any one DB)

- read the screen... what was the output of running the `rake` command?

We could check that the database table was created by firing up our trusty old command line tools.

```
  sqlite3 db/development.sqlite3
  .schema products
  .exit
```

What happens if you run `rake db:migrate` again?


# Adding columns to tables

So far, we dropped and recreated our tables manually with SQL commands (sometime stored for ease of use in `.sql` files) when we wanted to add columns to them. But this is not a practical, real-world solution. It very quickly gets very complicated to manage as our app, and our development team grows. So we use migrations to do this in Rails.

Rails gives us some help to generate migration files - we can list the fields and their types in the generate command, and if we name the migration appropriately, Rails even guesses the name of the table:

```
  # terminal
  rails generate migration AddPriceAndAvailableToProducts price:integer available:boolean
```

  - by using the pattern `Add....To....` for the migration name, Rails can infer that we're adding columns to a table, and it will create the migration with the assumed table name.

  - available data-types for columns:
    * :binary
    * :boolean
    * :date
    * :datetime
    * :decimal
    * :float
    * :integer
    * :primary_key
    * :string
    * :text
    * :time
    * :timestamp


# Schema.rb

When migrations run, Rails also updates the `schema.rb` file - the schema is a snapshot of your current database tables and fields.


# Rolling back

We can undo migrations; reverting the changes they made.

```
  # terminal
  rake db:rollback
```

This is useful if we run a migration, and then notice that it didn't alter the database the way we wanted. You can roll it back, and edit the migration file, before running it forward again.

Beware:
  - don't edit migrations which have been shared with other developers and run on their machines (or servers)
  - instead, write a new migration to make the changes you need

If you do edit migrations that have been run by others, you can quickly end up with databases that are out of sync on different team members' machines, and will require time-consuming manual intervention to resolve.


# Models and Migrations

Since ActiveRecord models map to tables, when you use the Rails generators to create a model, a table migration is created for you.

```
  rails generate model Customer name:string age:integer description:text approved:boolean credit_limit:decimal last_contact_at:datetime
```


# Removing columns from tables

We can use the same naming convention as create to automatically generate the migration file:

```
  rails generate migration RemoveAgeFromCustomers age:integer
```

Notice that it removes the column, but also has the data-type - that's not information needed for the 'remove', but if you roll this migration back, the reverse operation is to create the column; and to create a column, you need to know the data-type.

