# Databases and SQL Introduction

# What is a database?

> "a structured set of data held in a computer, especially one that is accessible in various ways."

The word "database" is one of those technical terms that *everyone* has heard, but some might struggle to define. Sometimes you'll hear them referred to as "DBMS" (Database Management Systems).

What databases do you know?

  - Microsoft SQL Server
  - Oracle
  - MySQL / MariaSQL
  - Microsoft Access
  - PostgreSQL
  - Mongo
  - Redis
  - Cassandra
  - DB2
  - Paradox
  - CSV
  - Excel
  - etc

Looking at the list of databases we've come up with, there's some repetition in the names - we'll look at what "SQL" is in a moment.

But there are SQL-type and NoSQL ("Not Only SQL"). Some of these databases are "relational", and some are object stores, some are tree structures, some are flat-files. We'll be spending the majority of our time getting an in-depth understanding of SQL databases, and will get exposure to other types.

Note: Although it won't any difference today, as you work with DBs more, it's worth knowing that a 'relation' is a view of data that comes back from a query, not the fact that there are 'relationships' between data.


# What is SQL?

"SQL" stands for "Structured Query Language" (pronouced either as "ess-queue-ell" or "sequel"), and is a special purporse programming language developed during the 1970's, and thoughout later decades, with the purpose of managing the structure and data of relational databases.

  - What do we store in databases?
  - What sorts of manipulations do we make to data in databases?
    - Create (we can't do anything unless we can put data in)
    - Read (once it's in there, we need to get it out)
    - Update (if it needs to change, we need to be able to change it)
    - Delete (we'll need to be able to remove data from our database)

We refer to these four operations as the "CRUD" that we perform on databases.


## PostgreSQL

```
  # terminal
  which psql
```

If there are any issues with running `psql`, ensure that the `postgresapp` is installed and running (it should have been configured in installfest), and that the path is updated to include it - launch `psql` from the system icon, and note the path used.

```
  # terminal
  psql
  \q  -- to quit
```


# CRUD

To work with data in databases we perform the four CRUD operations.
So we'll work through the SQL commands that give us that functionality.

Before we can do anything though, we need to create a table to store our records in. But before we can create a table, we have to create a database to put it in!

```
  # psql
  create database friends_application;
  \l
  \c friends_application
  \d
```

To create a table, we need to execute a SQL statement with the following syntax:

```
  # pseudo-SQL
  CREATE TABLE table_name (
    column_name1 data_type options,
    column_name2 data_type options,
    column_name3 data_type options,
    ...
  );
```

The structure of the database tables isn't our concern today, so we're going to use the following statement to create a `people` table to store the attributes of each person: name, age and sex.

Note: We're going to stick to a convention of having tables named as the plural of whatever is in them... if each record was a seperate 'invoice' the table would be 'invoices', if each record was an 'address' the table would be 'addresses'. What would the table be for an 'octopus'? Or a 'sheep'? ... okay, so we have some issues to be aware of with some object names.

```
  CREATE TABLE people (
    name VARCHAR(255),
    age INT2,
    sex CHAR(1)
    );
  \d
  \d people
```


## Create and Read

To "create" records in SQL, we use the `INSERT` clause. We "read" records with the `SELECT` clause.

```
  INSERT INTO PEOPLE (name) VALUES ('bob');

  SELECT * FROM PEOPLE;
  INSERT INTO people (age) VALUES (35);

  INSERT INTO people (name, age) VALUES ('jill', 22);
  SELECT * FROM PEOPLE;

  INSERT INTO people (sex, name, age) VALUES ('f', 'sue', 22);
  SELECT * FROM PEOPLE;

  # error values - what happens with these?
  INSERT INTO people (sex, name, age) VALUES ('f', 'sue', 'fsd');
  INSERT INTO people (sex, name, age) VALUES ('ff', 'sue', 31);
```

We use the `UPDATE` clause to change the values in existing records, and *must* use a `WHERE` clause to filter down matching records to apply the update to (without it, *every* record would be updated with the values you specify)

```
  UPDATE people SET sex = 'f' WHERE name = 'jill';
  SELECT * FROM PEOPLE;
```

You need to make your `WHERE` clause as specific as necessary to identify the records you want to target.

```
  INSERT INTO people (name, age) VALUES ('jill', 29);
  SELECT * FROM PEOPLE;

  UPDATE people SET age = 23 WHERE name = 'jill' and age = 22;
  SELECT * FROM PEOPLE;

  UPDATE people SET name = 'sam', sex = 'm' WHERE age = 35;
  SELECT * FROM PEOPLE;
```

To delete records we use the `DELETE` clasuse. But **be careful**, there's no undo! When a record is deleted from a DB it's gone for ever. "Undelete" in the database world is "restore from last night's backup" (if there *was* a backup...)

```
  DELETE FROM people WHERE name = 'bob';
  SELECT * FROM PEOPLE;
```


# Uniquely identifying rows

Let's assume that there are two 'freds' in our database, one is 21 year old, one is 22.

```
  INSERT INTO people (sex, name, age) VALUES ('m', 'fred', 22);
  INSERT INTO people (sex, name, age) VALUES ('m', 'fred', 21);
```

Then 21-year-old Fred has his birthday, and we update his record accordingly.

```
  UPDATE people SET age = 22 WHERE sex = 'm' AND name = 'fred' AND age = 21;
```

So now what happens when the other Fred's birthday comes along? We have no way of uniquely identifying his row, and any query we try to execute will update both Freds.

The answer to this is to add an arbitrary column to every table when we create it. That column will contain a number, which will be unique for each row in the DB, and ideally, is managed by the database itself, so we don't need to worry about adding it when we insert new records.

We'll create a table to store the pets of our people. We'll also write this in a text file now, so it will be easy to edit, and we can load this from the command line (the terminal .

```
  # terminal
  touch pets.sql

  # pets.sql
  CREATE TABLE pets (
    id SERIAL8,
    name VARCHAR(255),
    owner VARCHAR(255),
    dob DATE,
    dod DATE
  );

  # terminal
  psql -d friends_application -f pets.sql
```

The new `id` field is a `SERIAL8` type -- an internal type of PostgreSQL's, which will look after numbering for us in an eight-byte-integer field.

Note: Once defined, altering database schemas can be problematic ('involved' would be a good word to use) - beware of managing existing data. For the moment, when we need to, we'll just drop the whole table or DB and start again.

```
  INSERT INTO pets (name, owner, dob) VALUES ('Flynn', 'michael', '12 Jan 2004');
```

Repeat the INSERT a couple of times - see the incrementing index, even though all the other details are identical.

We can add "constraints" to our table definition, which will validate the data we try to enter against some basic rules.

  - A pet's name must be present
  - A DoB must be present, but if it's not specified, default to 1st Jan 1970
  - DoD must not be before BoB
  - A name must be unique for the owner

```
  # pets.sql
  DROP TABLE pets;

  CREATE TABLE pets (
    id SERIAL8 primary key,
    name VARCHAR(255) not null,
    owner VARCHAR(255),
    dob DATE not null default '1970-01-01',
    dod DATE check (dod >= dob)
  );

  ALTER TABLE pets
    ADD CONSTRAINT unique_pets_name_owner UNIQUE(name, owner);

  INSERT INTO pets (name, owner, dob) VALUES ('Flynn', 'michael', '12 Jan 2004');
```

Try again, and change values to test the constraints

Give it valid data and run again

```
  SELECT * FROM pets;
```

Look at the index... what's noteable?

It should be that there's a gap in the numbering - the records that failed constraints still used up numbers in the sequence.


# Foreign Keys

We associated pets with owners by adding the owner's name to the pets table. Can you anticipate anything wrong with this?

  - Duplication - If an ownner changes their name, it needs to be changed everywhere
  - What if two people have the same name?

What other solution could we use? Instead of storing the owner's name, what about storing the ID of their row in the people table?

This field is a 'key' that gives us access to a record in another table -- so we call it a "foreign key". Any column that is referring to a primary key in a foreign table is a foreign key.

```
  # pets.sql
  CREATE TABLE pets (
    id SERIAL8 primary key,
    name VARCHAR(255) not null,
    owner_id INT8,
    dob DATE not null default '1970-01-01',
    dod DATE check (dod >= dob)
  );
```

But what if one pet is shared by two owners? How could we structure the data?

  - Add an 'owner2_id' field to pets?
    - What if there are three owners, or a thousand? Are we going to add a field for each of the possible owners?


# Join tables

Let's create a new database to model a library. Our library will have people that can borrow books. Looking at the description of what our DB will do, all the nouns indicate tables we'll need.

  - we need a people table - what columns?
  - and a book table - what columns?
  - how do we link the together to track all the books a person reads?
    - Join table with two foreign keys

```
  CREATE DATABASE library_application;
```

In the terminal

```
  touch library_application.sql
  subl .
```

```
  -- https://gist.github.com/Pavling/833bd63081d3bd2667c8
  CREATE TABLE people
  (
    id SERIAL8 primary key,
    name VARCHAR(255)
  );

  CREATE TABLE books
  (
    id SERIAL8 primary key,
    name VARCHAR(255) not null,
    isbn VARCHAR(255) unique not null
  );

  CREATE TABLE borrowings
  (
    id SERIAL8 primary key,
    person_id INT8 references people(id),
    book_id INT8 references books(id)
  );
```

Note: Why don't we use an integer field for ISBN? The final digit can be an 'X'.

Foreign keys are generally named according to the convention "table_name_singular_id", unless another name makes more 'sense' (but it would always have `_id` to indicate it's a foreign key -- we might prefer `borrower_id`).

```
  psql -d library_application -f library_application.sql
  psql library_application

  \d

  INSERT INTO people (name) VALUES ('bill');
  INSERT INTO people (name) VALUES ('sally');
  INSERT INTO people (name) VALUES ('sue');
  SELECT * FROM people;

  INSERT INTO books (name, isbn) VALUES ('The Hobbit', '9780582186552');
  INSERT INTO books (name, isbn) VALUES ('Splinter of the Mind''s Eye', '9780345903327');
  INSERT INTO books (name, isbn) VALUES ('The Day of the Triffids', '9780141912110');
  SELECT * FROM books;

  INSERT INTO borrowings (person_id, book_id) VALUES (2, 3);
  INSERT INTO borrowings (person_id, book_id) VALUES (2, 1);
  INSERT INTO borrowings (person_id, book_id) VALUES (2, 2);
  SELECT * FROM borrowings;
```

What if a person tries to borrow a book that doesn't exist:

```
  INSERT INTO borrowings (person_id, book_id) VALUES (2, 50);
```

Add some extra people.

```
  INSERT INTO borrowings (person_id, book_id) VALUES (2, 3);
  INSERT INTO borrowings (person_id, book_id) VALUES (2, 1);
```

How do you find out the names of the people who have borrowed 'The Hobbit'?

```
  -- First, find out the ID of the book.
  SELECT * FROM books WHERE name = 'The Hobbit';

  -- Then by getting all the borrowings for the book.
  SELECT * FROM borrowings WHERE book_id = 1;

  -- We can just ask for person_id for our purposes.
  SELECT person_id FROM borrowings WHERE book_id = 1;

  -- Now we can get the people's names from the person_ids. Note that (2,3) is kind of like an array.
  SELECT name FROM people WHERE id IN (2,3);
```

We had to execute three queries here to get the data we wanted, which isn't very efficient. But it got us there. Later, we'll learn how to join these queries together, but that's enough for today.


# Further reading

There's much in SQL statements we've not covered yet: clauses for ordering results, limiting the amount of results, indexes, 'normalisation', conditions in `WHERE` clauses, joining queries to use foreign keys to get better information. Lots more too.

It would certainly be worth researching these.
