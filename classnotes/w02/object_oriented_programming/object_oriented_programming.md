# Object Oriented Programming

# Intro to OOP

Just like in real life, **everything** in Object Oriented Programming (OOP) is an object. Objects have methods and properties, much like in real life (a pen, for example, will have a "write" method, and an "ink level" property). Our challenge is to design how these objects interact with each other to use them to solve coding problems.

In Ruby, we use 'classes' (which are also objects) to specify the form of an object. Think of a class as a blueprint, or a "cookie cutter", from which we create 'instances'. The instances will be identically formed, but separate objects.


# Creating your own class

To define a class, we use the keyword "class" followed by the class' name (class names are Ruby constants, and are written using the CamelCase convention). A matching "end" keyword defines where the class finishes.

Let's define a `Person` class with a method that lets instances say words that are given to them.

```
  require 'pry-byebug'

  class Person
    def say(words)
      puts "I say, #{words}"
    end
  end

  bob = Person.new

  binding.pry;''
```

We can ask `bob` what type of object it is when we run our file.

```
  bob.class
  => Person
```

We can call the `.say` method which we defined in the `Person` class. This is an instance method. We are calling it on the instance (rather than the class itself):

```
  bob.say("hello")
  => "I say, hello"
  Person.say("hello")
  => NoMethodError: undefined method `say' for Person:Class
```

If we create another instance of `Person`, we can see that it is a totally different object to `bob`.

```
  fred = Person.new
  bob.object_id
  => 226765960
  fred.object_id
  => 227583904
```

Notice they have different IDs. This illustrates that although they are from the same class, they are separate instances of this class. The `.object_id` method is not defined in our `Person` class, but has come from the internals of Ruby. We'll explain how later in a later lesson.


# Properties

Let's imagine we want to be able to ask a `Person` what their name is. To do this, we will need some functionality added to the class.

```
  def first_name
    "I don't know what my name is"
  end
```

Then we can call this method.

```
  bob.first_name
  => "I don't know what my name is"
```

If I want to be able to tell a `Person` what their name is, I will need two things:

  1) Another method to call to set the name
  2) A variable to store the name in case it's asked for later in the object's life

The variable we will use is an instance variable, because this type of variable is available across the scope of a whole instance of a class.

```
  def set_first_name(value)
    @first_name = value
  end

  def first_name
    @first_name
  end
```

We can call these methods on our objects.

```
  bob.set_first_name('Bob')
  bob.first_name
  => "Bob"
```

Methods that just set a variable are referred to as "setters", and those that returns a variable's value are "getters" (or "writers" and "readers").

Ruby allows us to make use of some "syntactic sugar" to make setters a little easier on the eye. We can re-write the `set_first_name` method to make is work like we set variables.

```
  # Person class
  def first_name=(value)
    @first_name = value
  end

  # call the method
  bob.first_name = 'Bob'
```

This "sugar" is a facility of Ruby -- not all object oriented programming languages let us do exactly this. But all different languages have their little nuances.

It is so common that we'll need to have properties of classes that we'll want to read and write that Ruby gives us *another* bit of sugar.

```
  class Person
    attr_reader :first_name
    attr_writer :first_name

    def say(words)
      puts "I say, #{words}"
    end
  end

  alice = Person.new
  alice.first_name = "Alice"
  alice.first_name
  => "Alice"
```

And an **even shorter** way of doing *exactly the same*... (this constant changing is start to wear us out...)

```
  class Person
    attr_accessor :first_name

    def say(words)
      puts "I say, #{words}"
    end
  end
```

Sorry to go the long way round, but not all programming languages have this sugary syntax, so we need to recognise what's going on behind the scenes.


# Initializing Objects

When creating an instance of a class, we can also pass arguments to the `.new` method, and handle these arguments on the class side. That's where the "initialize" method comes in handy.

The "initialize" method is a standard Ruby class method, and may take a list of parameters like any other Ruby method.

```
  class Person
    attr_accessor :first_name, :last_name, :age

    def initialize(first_name, last_name, age)
       @first_name = first_name
       @last_name = last_name
       @age = age
    end

    def say(words)
      puts "I say, #{words}"
    end
  end
```

You may frequently see a hash passed to an initializer to set initial attributes.

```
    def initialize(options={})
      @first_name = options[:last_name]
      @last_name = options[:first_name]
      @age = options[:age]
    end
  end

  fred = Person.new(age: 25)
```


# Class variables

When we covered the different types of variables that Ruby gives us, we said that we would be very unlikely to ever need "class variables". These are variables which which are shared between all instances of a class. Class variables are prefixed with two @ characters (@@).

```
  class Person
    attr_accessor :first_name, :last_name, :age

    @@toe_count = 10

    def initialize(options={})
      @first_name = options[:first_name]
      @last_name = options[:last_name]
      @age = options[:age]
    end

    def toe_count
      @@toe_count
    end

    def toe_count=(value)
      @@toe_count = value
    end
  end
```

```
  fred = Person.new
  wilma = Person.new
  fred.toe_count
  => 10
  wilma.toe_count
  => 10
  fred.toe_count = 9
  fred.toe_count
  => 9
  wilma.toe_count
  => 9
```

Whoa! I think it's possible to see that that that kind of functionality could get us tying ourselves in knots pretty quickly -- best to leave class variables alone until we're a bit more comfortable with all the other aspects of OO coding.


# Class methods

One (!) of the ways of defining a class method is to put "self." before the method name. To call a class method, you don't need an instance, you just change the method name to the class name.

A most common use for class methods is as "constructor" or "factory" methods: which return an instance of the class. We typically put any class method definitions at the top of the class, above any instance method definitions.

We'll create a class method, which will allow our people to breed. So what functionality do we need to model in breeding? We need to take random attributes from two people, and mix them together to make a third. Okay, in "real life" objects, children don't inherit the age and name attributes of their parents, but we should be able to see how we could do the same if we had attributes for sex, hair-colour, ear-shape, etc.

```
  # person class
  def self.breed(person1, person2)
    options = {
      first_name: [person1, person2].sample.first_name,
      age: [person1, person2].sample.age
    }

    Person.new(options)
  end

  # irb
  michael = Person.new(first_name: 'Michael', age: 42)
  katherine = Person.new(first_name: 'Katherine', age: 31)

  Person.breed(michael, katherine)
```

We could have some fun with this... how much work would be involved to make `self.breed` accept a variable amount of `Person` instances as arguments, and pick from any of their attributes?


# Class Constants

If you define a constant inside a class you can use it anywhere inside the class, and also outside the class if you prefix it with the class name. By convention, we write the name of class constants in all-caps.

```
  class Hacker
    LANGUAGE = "Ruby"

    def initialize
      puts "just created a new #{LANGUAGE} hacker"
    end
  end

  Hacker.new
  => just created a new Ruby hacker

  Hacker::LANGUAGE
  => "Ruby"
```

NOTE: The double-colon is syntax used to access constants in classes. We'll come across it later in other situations too.
