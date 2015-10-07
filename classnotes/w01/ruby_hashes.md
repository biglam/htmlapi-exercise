# Ruby Hashes

# What is a hash?

A Hash is a dictionary-like collection of unique keys and associated values. Similar constructs in other languages can be referred to as Associative Arrays, or Key-Value Pair Collections. They are similar to Arrays, but there are important, useful differences.

Can you remind me of some of the features of Arrays?

  - Collections of objects
  - Enumerable
  - Ordered
  - Indexed by integer
  - One object per element

Hashes share some of these features with Arrays: They are Enumerable, they collect objects together, but where Array uses integers as its index, a Hash allows you to use any object as a key; though generally – more than nine-times-out-of-ten – for most simplicity and convention, Symbols are used as Hash keys.

However, a Hash is unlike an Array in that its elements are not stored in any particular order (well... they never used to be; since Ruby 1.9 they are, but in other languages they're still not... I find it best to assume they're not, and not to rely on them being ordered), and they are retrieved with the "key" instead of by their position in the collection.

# Why use a hash vs array?

Hashes are best used where you want to know a little more than just its value of the element you're storing in the collection. For instance, if you had a class of students, and you wanted to do some calculations on their grades from a test, an Array would let you save each of their scores in seperate elements, but a Hash would allow you to store each student's name as the key for the score value too.

* Can you suggest any other uses for Hashes?

  - Configuration options
  - Method parameters


# Create a Hash

The concept of Hashes can be a little abstract, so it's best to play with them in a console to see the effect.

We can create hashes by instanciating a new Hash object:

```
  my_hash = Hash.new
  => {}
```

As you see, Ruby represents Hashes with curly-braces (just as an array was a pair of square-braces), and we can shortcut their creation that way.

```
  my_hash = {}
  => {}
```

We can also create "Hash Literals"; that is, Hashes that are pre-populated with key-value pairs.

```
  my_hash = {:top => 5, :right => 6, :bottom => 10, :left => 10}
  => {:top => 5, :right => 6, :bottom => 10, :left => 10}
```

The '=>' sign is sometimes referred to as a 'hash rocket' or – a little uncaring – a 'fat arrow', and is used to indicate the association of a key and its value.

If all the keys of my Hash are Symbols, then we can use a shortcut syntax.

```
  my_hash = {top: 5, right: 6, bottom: 10, left: 10}
  => {:top => 5, :right => 6, :bottom => 10, :left => 10}
```

This is a very familiar syntax: you may have come across very similar structures in CSS and JavaScript.


# Access items in a hash (vs. an array)

In an array, we access elements by their index.

```
  my_array = [:top, :right, :bottom, :left]
  => [:top, :right, :bottom, :left]
  my_array[1]
  => :right
  my_array.last
  => :left
  my_array[-1]
  => :left
  my_array[6]
  => nil
```

In a Hash, which is not indexed by position, but by key, we use the key to access elements.

```
  my_hash = {top: 5, right: 6, bottom: 10, left: 10}
  => {:top => 5, :right => 6, :bottom => 10, :left => 10}
  my_hash[:top]
  => 5
  my_hash[:left]
  => 10
```

There's a method called 'fetch' on Hash, which is frequently preferred.

```
  my_hash.fetch(:left)
  => 10
```

Requests for keys which don't exist return nil.

```
  my_hash[:center]
  => nil
```

`.fetch` will raise an exception...

```
  my_hash.fetch(:center)
  => KeyError: key not found: :center
```

...or perform some other action.

```
  my_hash.fetch(:center, 0)
  => 0

  my_hash.fetch(:center) { [0,1].sample }
  => ???? # what does this do? and why?
```

We can add and replace items in the Hash by writing to their key.

```
  my_hash[:center] = 55
  => 55
  my_hash[:top] = 100
  => 100
  my_hash
  => {:top => 100, :right => 6, :bottom => 10, :left => 10, :center => 55}
```

But once it's set, there will always be an entry for a key unless we tell the Hash to delete it

```
  my_hash[:center] = nil
  => nil
  my_hash
  => {:top => 100, :right => 6, :bottom => 10, :left => 10, :center => nil} # (remember, even 'nil' is an object)
  my_hash.delete(:center)
  => nil
  my_hash
  => {:top => 100, :right => 6, :bottom => 10, :left => 10}
```


## In Summary

Hashes are associative arrays – you may not be able to rely on their order, but they're indexed by their key, which makes them great for storing extra information (meta-data) about their contents.

Any questions about Hashes?


### Hash tricks

Instanciate with an even number of parameters.

```
  Hash[:color, :red, :padding, 11]
  => {:color => :red, :padding => 11)

or with the Array splat operator.

```
  options = [:color, :red, :padding, 11]
  Hash[*options]
  => {:color => :red, :padding => 11)
```
