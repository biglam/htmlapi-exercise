### title

Ruby Basics

### topic

### objectives

* Identify key aspects of the Ruby language
* Be able to use the Ruby command line 'IRB'
* Exposure to:
  - data types
  - variables
  - logical operators
  - expression evaluation

### standards

### materials

### summary

Introduce the basic concepts of Ruby, and check for understanding of topics that should have been covered in prework.

Start to instill programming best-practices of naming conventions and language idiom.

This lesson may run over an hour-and-a-half if there's a lot of student interaction. So be prepared to break half-way if necessary.


### assessment

Use the interaction with the class to gauge the level of understanding throughout the lesson.

At the end of the class, put the following questions to them:

  1) Assign to the value `6` to the variable `number_six`
  2) What is the datatype of `"Matz"`?
  3) What do the following expressions evaluate to:
    * `"Cool" + "Cool" + "Cool"`
    * `t = "Troy"
      a = "Abed"
      "#{t} and #{a} in the Morning"`
    * `10 * 3`
    * `10 ** 3`
    * `10 % 3`
    * `10 / 3`
    * `0.7 + 0.1`
  4) Can you explain why the expressions all give the same result?
    * `"Ronnie " + "Pickering"`
    * `"Ronnie ".+("Pickering")`
    * `"Ronnie ".send(:+, "Pickering")`
  5) Please fix the following buggy expressions:
    * `number six = 6`
    * `"Maroon" + 5`
    * `ture == flase`


### follow-up

====================

## What is Ruby

We're going to go over the basics of the Ruby programming language, and try lots of combinations of functionality as we can to increase our skills.

Created in 1995 by Yukihiro Matsumoto

> "I hope to see Ruby help every programmer in the world to be productive, and to enjoy programming, and to be happy. That is the primary purpose of Ruby language."

It's an interpreted scripting language.

- What do we use programming languages for?
- Why should we use one over the other?

Essentially, there's no "right" or "best" language, just the right one or the best one for the situation you find yourself in.


### Working with Ruby

`irb` will open an Interactive Ruby environment in the console (we exit it by typing `quit` or `exit`).

'irb' stands for "Interactive RuBy, and typing that into a terminal launches a ruby REPL.

  * REPL = Read, evaluate, print, loop => good for experimenting with short snippets of code.

irb allows to quickly try snippets of ruby outside of your application.

Use it frequently to test lines of code or to experiment outside of the bigger programs we will write later.


## Objects Overview

Ruby is an Object Oriented language. We'll cover OO programming in depth later, but for now, if we want to know what Ruby thinks something is, we can ask it with the method `.class`

*Everything* in Ruby is an object, and objects have a "class" (a 'type').

```
  # irb
  1.class
  "1".class
  1.0.class # or "(1.0).class" - we can use parentheses for disambiguation
```

To prove everything is an object, you can call the method `.object_id` to see the unique identifier that Ruby has given to the object.


## Data Types


## Variables

We can store values in "variables" - they're variable because the values can change (we also call this 'mutability')


### Types of variables

`variable`   => local variable
`@variable`  => instance variable
`@@variable` => class variable
`$variable`  => global variable
`VARIABLE`   => constant variable (funny name!)

For now, we will mainly be using local and instance variables. We'll *never* use global variables - until we know why.


### Assigning values to variables

The name of a variable is almost totally up to you to define. Pick a name, and tell it what value it equals:

```
  # irb
  character = "Fred Flintstone"
  age = 24
  bald = false
```

You can reassign variables in Ruby without any constraints (you get warned when reassigning constants, but they get reassigned... not very constant...), you can even change the type of data they hold, which can be confusing if you're not careful.

```
  # irb
  character = "Wilma Flintstone"
  age = "twenty"
  bald = 77
```


### Naming conventions

Ruby has fairly strong opinions about how you should write your code, but very little in the way of enforcement. So you're free to break the rules if you wish, with no real worry about consequences...

... apart from tutting and disapproving headshakes from your peers.

Keeping to style guides means that other developers can more quickly understand your code (and you theirs), and contribute quickly to a code base without making it hard for others to follow.

We use **CamelCaseForClasses**, **UPPER_CASE_SNAKE_CASE_FOR_CONSTANTS**, and **lower_case_snake_case_for_everything_else**.

[Ruby style guide naming conventions](https://github.com/bbatsov/ruby-style-guide#naming)


## RubyGems

RubyGems is a package manager for the Ruby programming language that provides a standard format for distributing Ruby programs and libraries. Simply put, it manages the installation of "gems" (ruby libraries).

To see what gems you have installed:

```
  # terminal
  gem list
```

To install a new gem:

```
  # terminal
  gem install some_gem_name
```

For example:

```
  # terminal
  gem install rainbow
  Fetching: rainbow-2.0.0.gem (100%)
  => Successfully installed rainbow-2.0.0
```

Back in irb:

```
  # irb
  require "rainbow/ext/string"
  string = "hello world"
  print string.color(:red)
  # or
  print Rainbow(string).red
```

[Rainbow Gem Github](https://github.com/sickill/rainbow)


## Ruby Basics in IRB

```
  # irb
  x = 1
  x
  x.class
  x + 1
  x
  x += 1
```

Other operators... `/ * - ** %`


### "Duck typing"

```
  # irb
  10 / 2
  5 / 2
```

??? What?! Why is it "2"?!! Can't Ruby do maths?! We found a bug!

Nope... it's just that we gave Ruby two integers, so it gave us an integer as the result. The answer is to do the following:

```
  # irb
  5 / 2.0
```

By making one of the values a float, Ruby figures out to treat the other value as if it were a float, and gives us a float back. This is called "Type Coercion" - also known as "Duck Typing" (it looks like a duck, and quacks like a duck, so assume it's a duck).


#### Can we duck type strings?

What answer do I want? How can the computer (or Ruby) know?

  - `"5" + 5` # do I want "55" or "10"?
  - How to get "10"? `"5".to_i + 5`

If Ruby can't "implicitly" coerce types, we have to be "explicit" in the types we want.

  - How to get "55"? `"5" + 5.to_s`

Adding strings together is called "String Concatenation"

What about other operations? Does it make sense to divide strings?

```
  # irb
  "5" / 2.0
  2.0 / "5"
  "5".to_i
  "5".to_i / 2.0
```

Sometimes you can get unexpected results:

```
  # irb
  "Hello".to_i
  "4vid".to_i
```


## Equality, evaluation, boolean


### Equality

We've said that Ruby knows the type of objects, but will coerce them for us if it can, but how do we tell if two objects are the same, different, bigger, smaller?

```
  # irb
  a = "hello"
  b = "hello"
  a == b
  a != "world"
  1 > 2
  2 < 1
  1 >= 1
```

### Evaluating Strings

```
  # irb
  "a" > "b"
  "b" > "a"
  "a" > "A" # Capital 'A' comes before lower-case 'a' in the character-set - so is 'smaller'
```

### Booleans

Booleans are values that can only be true or false. But since everything in Ruby is an object - true and false are instances of objects too:

- `true.class` is TrueClass
- `false.class` is FalseClass

We frequently use "boolean logic" to make decisions depending on the 'truthiness' or 'falsiness' of values. This has a fundamental relationship to the construction of digital computing, where the smallest components of transistors and processors are essentially switches that can be only either 'on' or 'off'.

- `||` - or
- `&&` - and
- `!` - not

```
  # irb
  true || false
  false || true
  false && true
  true && true
  nil && true
  !true
  !false
  x = "hello"
  !x
  x && true
  x = nil
  !x
  x && true
```


### Summary

Ruby is the programming language we're going to be using for the majority of the course; for the majority of the fundamental learning.

It's a "nice" programming language, but it does have its quirky bits.

