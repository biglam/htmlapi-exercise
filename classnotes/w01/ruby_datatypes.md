
# Ruby Datatypes - Strings and Symbols


# Strings

Recap from Ruby Basics lesson:

  * Numbers
    * Integers and Floats
  * Strings
  * Booleans


## String Concatention

We can join Strings together by using the `+` method, the same as adding integers:

```
  "hello" + "world"
  "hello" + " " + "world"
  h = "hello"
  w = "world"
  space = " "
  h + space + w
```

But Ruby favours "string interpolation", where variables are put inside a String rather than "added" together:

```
  h = "world"
  "hello #{h}"
  "hello #{1}" # automatically casts to String
```


## String Methods

"Methods" are one of the ways we give behaviour to objects in programming. Methods can make the object do something, or tell you something about itself.

We can call methods on Strings (or String variables -- "String literals" are the things in quotes) by adding a full-stop and then the name of the method. Ruby returns the result of the method call.

```
  "aardvark".is_a?(String)
  => true
```

We can ask any object what methods are available to it with the "methods" method: `"aardvark".methods`.

Have a play in IRB with some of the methods and see what they do.

```
  "aardvark".length
  "The quick brown fox jumps the lazy dog".split
  "The quick brown fox jumps the lazy dog".split('o')
  "Hello".next
```

If any of the methods are not self-explanatory, read the [API documentation](http://ruby-doc.org/core-2.1.4/String.html).


## "Bang" Methods

Notice that there is some duplication in the names of the methods; `upcase` (among others) is there twice. But look carefully, and you'll see they're slightly different -- one has an exclamation mark after it - `upcase!`. We call these "bang" methods.

The 'bang' is a general indication that the method does "something dangerous". Generally, it means that the method will change (mutate) the value of the receiver (the object you called the method on). Non-bang methods generally return a result, but leave the receiver as it was.

```
  animal = "aardvark"
  => "aardvark"
  animal.upcase
  => "AARDVARK"
  animal
  => "aardvark"
  animal.upcase!
  => "AARDVARK"
  animal
  => "AARDVARK"
```

Note: But be careful -- this is not a hard-and-fast rule. Some non-bang methods *do* mutate the receiver. But you'll often find that these destructive methods don't have a non-destructive alternative.

```
  animal.clear
  => ""
  animal
  => ""
```


# Symbols

## What is a Symbol?

Symbols can be thought of as a special type of String, used most often in Ruby to represent names of things – they give a human-readable place in code, but are efficient for the computer too.

They are generated using the "colon-name" (:name) and "colon-string" (:"name") syntax, and by intern and to_sym methods. You will most often see them written in code with the "colon-name" style.

The largest important difference to Strings is that Symbols are immutable. Mutable objects can be changed after assignment while immutable objects cannot.

```
  greeting = "hello" # assiging a String literal to a variable
  => "hello"
  greeting << " world" # appending another value to the String
  => "hello world"
```

Being mutable, Strings can have their share of issues in terms of creating unexpected results and reduced performance. It is for this reason Ruby also offers programmers the choice of Symbols.

```
  symbol = :hello # assiging a value to a symbol
  => :hello
  symbol << " world" # appending another value to the symbol
  => NoMethodError: undefined method '<<' for :hello:Symbol
```

After the first use of a Symbol all further useages of it take no extra memory – they're all the same object. This can save memory over large numbers of identical literal strings, and enhance runtime speed – at least to some degree.

Symbols don't offer the large set of methods that Strings do (like, ".upcase", ".reverse", ".prepend", etc); all the things you can do to Stings, you can't do all the same to Symbols – but it's because of this they are more prefered for using in some cases. Since once they're set, they can never change – they can't accidentally change, which is a small protection against bugs.

But if you need a Symbol to behave like a String, then you can generate a String from it with the `.to_s` method.


## How to create and manipulate Symbols

We can best illustrate them by trying them in the Ruby console:

First we will try three Strings:

```
  puts "hello".object_id
  => 3102163
  puts "hello".object_id
  => 3098211
  puts "hello".object_id
  => 3093564
```

Then we'll try three Symbols:

```
  puts :"hello".object_id
  => 234518
  puts :"hello".object_id
  => 234518
  puts :"hello".object_id
  => 234518
```

As you see, the object IDs for the Symbols are the same, while the Strings are all different – the Strings are three different instances, while the Symbols are all pointing to the same single instance.
And it doesn't matter how the Symbol is instanciated:

```
  puts :hello.object_id
  => 234518
  puts "hello".intern.object_id
  => 234518
  hello_variable = "hello"; puts :"#{hello_variable}".to_sym.object_id
  => 234518
```

Look at the amount of instance methods of String (c.166) compared to Symbol (c.80). How many of Symbol's are 'bang' methods?


## Why use Symbol vs a String?

So what are the benefits of using Symbols:

  - Immutability
  - Performance
  - Legibility of 'names of things' (important when you're reading lots of code)
  - Simplicity

And did you pick up on any downsides of using them?

  - Not so many methods
  - Not as versitile

One of the main places you will use Symbols in Ruby is as 'keys' in Hashes. Earlier we covered the use of Arrays as a way of collecting objects into a container, but now we're going to explore a little about these other type of collection.

Any questions about Symbols?

