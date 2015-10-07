# Ruby Blocks & Enumeration

We have already touched on blocks -- when we talked about loops we mentioned that "more idiomatic Ruby" might look like this:

```
  10.times { |i| puts i }
```

In that example, the block is the curly braces, and everything they contain.

A block is a portion of code that is passed to a method -- in fact, blocks can be considered little methods of their own, just with no name.

We'll frequently use these with "enumerable" objects (Arrays, Hashes, etc), but they crop up everywhere in Ruby. The principle of anonymous methods is used in many other programming languages too.

For this lesson we will use some of the enumerable methods to demonstrate blocks. You will use these methods *all the time* in your Ruby programming career, so become very familar with them.

But get familiar quickly with relevant search terms for finding out more. There are too many to memorize, so try to remember that there are all these sorts of functionality, and how to find them.

- Googling for "ruby api array", "ruby api enumerable"
- Remember to search for solutions (rather than writing your own code every time)
- Read the API docs in down-time (fun!) -- you'll learn something new every time


# Putting blocks to use

Let's create a method that prints out a name (the argument passed to it) followed by a space.

```
  def print_name(name)
    print name, " "
  end
```

And then take an array of names, and iterate it, calling the 'print_name' method for each of its elements. To begin, we'll use the simple "for...in" syntax to get each element by its index.

```
  names = %w(Fred Wilma Barney)

  for i in 0..names.size
    print_name(names[i])
  end
```

We can refactor this code to use a block.

```
  %w(Fred Wilma Barney).each do |name|
    print_name(name)
  end
```

Which can be further simplified to this.

```
  %w(Fred Wilma Barney).each { |name| print_name(name) }
```

We generally use the curly-braces for one-line blocks, and "do..end" for multi-line blocks.


## Using Blocks with Enumeration

I keep using this word "enumerable" (or "enumerate" or "enumeration") as it is the name in Ruby of the collection of functionality related to collections of objects. There are 50-ish methods added to collections by the Enumerable functionality; the following six are well worth becoming very friendly with.

The first is the most important; the cornerstone of enumerable functionality. The others are referred to as the "Ect" methods (for reasons that should become obvious).


### Each

Underpinning the ability of being to enumerate collections in Ruby is the `.each` method. It allows you to run a block against each element in a collection. Here's an example with a Range object.

```
  (1..100).each { |i| puts i if i % 7 == 0 }
```

And others with an Array.

```
  %w(Fred Wilma Barney).each { |name| puts name * 3 }

  [1, 10, 45, 15, 2, 20, 100, 4].each do |age|
    puts case age
      when 0..1
        "infant"
      when 2..4
        "toddler"
      when 5..12
        "child"
      when 13..18
        "teen"
      else
        "adult"
      end
    end
```

The value within the pipes (`||`) is the variable name which contains the value of the each element as we iterate. `age` is a just a variable name (it's worth saying twice!), with no special meaning to the work. It can be changed to whatever value you like (it could be "squirrel" or "aardvark"). But like any other variable, pick a name that makes sense: if you're iterating an array of invoices, call the block variable "invoice", if it's an array of people, call each "person".

The `age` block variable's scoped is limited to the block -- you cannot access it outside the block, and Ruby will raise an error about the variable not being defined if you try.


### Collect (AKA Map)

You will incredibly frequently want to take a collection, transform it somehow, and return a new collection. `.collect` and `.map` are synonyms for this functionality (and we'll use `.map` because it's got fewer characters to type, and we're lazy, like good programmers should be).

```
  %w(Fred Wilma Barney).map { |name| name.reverse }
```


### Select

Sometimes, you'll want to select a subset of a collection. The selection criteria can be defined in a block. Whatever elements return true for the block get selected.

```
  (1..10).select { |i| i.even? }
```


### Detect

Alternatively, you may just want to detect the first element that returns true for a collection.

```
  (1..10).detect { |i| i.even? }
```


### Reject

Practically the direct opposite of `.select`, if you want all the elements that return true to be removed from your collection.

```
  (1..10).reject { |i| i.even? }
```


### Inject (AKA Reduce)

Demonstrating the power of the block functionality, `.inject` takes the return value from the first iteration, and injects it into the next as one of two block variables (the other variable being the element being iterated). This process of injecting the result into the next block continues, until the whole collection is reduced to one value (hence the other name for this method).

It may be easiest to show as taking a collection of numbers and adding them all together.

```
  [1,2,3,4,5].reduce { |sum, number| sum + number }
```



- Some of the API references:
  [Enumerable](http://www.ruby-doc.org/core-2.1.4/Enumerable.html)
  [Hash](http://www.ruby-doc.org/core-2.1.4/Hash.html)
  [Array](http://www.ruby-doc.org/core-2.1.4/Array.html)





