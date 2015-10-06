# Ruby Functions

Although you should have come across functions in the pre-work, it's important to go over them and make sure that you are 100% clear.


## What are functions? How are they different to methods?

The words  'function' and 'method' are often used interchangeably although they are slightly different...


### Function

- A 'function' is a chunk of code that can be called by name.

It can be passed data to operate on (ie. the parameters) and can optionally return data (the return value). All data that is passed to a function is explicitly passed.

```
  walk("Fred")
```


### Method

- A 'method' is a function associated with an object.

In most respects it is identical to a function except for two key differences.

  1. It is implicitly passed the object for which it was called.
  2. It is able to operate on data that is contained within the class (remembering that an object is an instance of a class - the class is the definition, the object is an instance of that data)

```
  fred.walk
```


## So what do they do?

We use them to encapsulate meaningful pieces of code into small, isolated constructs

We've been using some methods already like `.to_i`, `.chomp`.

In Ruby, methods *always* return a value - whether we want them to or not.  By default, the result of the last evaluated expression is returned, but you can also use the `return` keyword to explicitly return a value.


## Anatomy of a Method

Defined with `def` then method name, end with `end`

  - name can't begin with a number
  - name *must* begin with a lower-case character
  - special characters are allowed and imply functionality (? for predicate, ! or 'bang', = for setters, etc)


### Good/bad method names

It's always useful to use method names that say what the method does.


## First functions

Look at the functions.rb file that asks users to guess the number.

Run the `ruby_functions.rb` file.

There is duplication in there... twice, we do a `gets.chomp.to_i` - so let's DRY that up to be a function called `get_value`.

```
  # functions.rb
  def get_value
    # put me in first, because Ruby is interpreted...
    gets.chomp.to_i
  end

  my_number = 5
  puts "What number am I thinking of? "
  value = gets.to_i

  until value == my_number
    print "nope... try again: "
    value = get_value
  end

  puts "yes!"
```

You can also abstract functionality that might 'make sense' to live in its own function:

```
  # functions.rb
  def get_value
    # put me in first, because Ruby is interpreted...
    gets.chomp.to_i
  end

  def warn_user
    print "nope... try again: "
  end

  my_number = 5
  puts "What number am I thinking of? "
  value = get_value

  until value == my_number
    warn_user
    value = get_value
  end

  puts "yes!"
```

This means we can use that function again.


### Be DRY

DRY - is a guiding principle of coding (especially in Ruby).

- **D**on't
- **R**epeat
- **Y**ourself


## Passing arguments to methods

Arguments (also called 'Parameters') are values passed to a function, and are 'captured' into variable names in the definition of the method.

```
  def greet(name)
    puts "hello, #{name}"
  end

  greet('Fred')
  => "hello, Fred"
```

Parameters can be specified to be optional by setting a default value:

```
  def greet(name="you") ...
```

Multiple parameters are separated with a comma:

```
  def greet(first_name, last_name) ...
```

If we want to pass a variable amount of parameters, we can use a 'splat' operator to capture all the given parameters as a single array:

```
  def greet(*names)
    puts "hello, #{names.join(', ')}"
  end

  greet 'Barney', 'Wilma', 'Fred', 'Betty'
  => hello, Barney, Wilma, Fred, Betty
```
