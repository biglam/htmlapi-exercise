# Ruby Arrays

# What are arrays?

> "an arrangement of items at equally spaced addresses in computer memory"

Sounds very "computer sciency"... what it means is, that an array is "one thing", with lots of other things inside it. Like a big basket, or bag, or box.

But they're actually more than this: arrays are 'indexed', that is, you can access the things inside it by their index -- different to just a bag or basket with things jumbled inside. More like a warehouse (Ikea?) with the shelves numbered for you to pick items from, or a menu in a Chinese restaurant.

What is *actually* on the shelf, or the menu, is moderately irrelevant. What's important is that you know that if there was a "Lack(tm)" table there yesterday, the same thing should be on the same shelf today (as long as no-one has changed the labels on the shelves...)


## What are arrays for in programming

Arrays are a useful way of collecting up related information, for passing around in bulk, or for later enumerating one-at-a-time. As such, if you ever need to produce anything that acts like a queue, or a list, or a table (spreadsheet-like), then arrays may well be useful.


## What are they not for

Arrays are really rather dumb, in fact, the shelf/menu analogy is a little misleading, as there's much more information on a menu or warehouse pick-list than an array knows about its elements (each item in an array is generally referred to as an "element").

All an array knows is whether or not *something* is at a given index; and that index (often referred to as 'key') is an integer. The first element in an array is at index zero, and the amount of elements can generally go up as high as your computer/programming language will allow. Some languages require that you specify how big is each new array you use (to know how much space to allocate in memory), but Ruby is a bit more flexible, and will grow arrays automatically to fit as many items as you add to it.

NOTE: Precisely *why* array indexes start from zero rather than one is a discussion for another day.


# Using Arrays

So to back-pedal on the analogies -- arrays may work for menus, *if* the menu is just a list of numbers from zero (with no names next to them too).

```
  # irb
  my_array = ['fred', 'wilma', 'betty', 'barney']
  my_array
```

Since arrays are an instance of an object themselves, you can call methods on them to get information about their properties.

```
  my_array.class
  my_array.size
```

And there are helpful methods to get elements from the array.

```
  my_array.first
  my_array.first(2)
  my_array.last
  my_array.last(2)
```

And to manipulate the array.

```
  my_array.reverse
  my_array.rotate
  my_array.shuffle
  my_array.sample
```

To get *any* element from an array, you can access it by its integer index (but you have to *know* what that index is...); either the index from the start of the array, or from the end.

```
  my_array[0]
  my_array[-1]
  my_array[100] # what would you expect this to return? then see
```


## Manipulating arrays

We will so often need to add and remove items from arrays, that there are numerous ways to do it.

We can add/remove to the end of the array.

```
  my_array.push('bammbamm')
  my_array.pop
  my_array << 'bamm-bamm' # referred to as the "shovel" operator
```

And to the start of the array.

```
  my_array.shift
  my_array.unshift('dino')
```

And of course, by index.

```
  my_array[1] = 'pebbles' # notice that this overwrites whatever was already there -- any existing value is gone for ever (like re-assigning a variable)
  my_array[100] = 'hoppy' # think about what the `my_array` variable might look like now... then see
```

We can add arrays together (mixing literal arrays with variables - Ruby doesn't mind), and subtract one from the other. Intersect, and union them.

```
  [1, 2, 3] + [3, 4, 5] # add/concatenate arrays into one
  [1, 2, 3] - [3, 4, 5] # remove any elements from the first array that are in the second array
  [1, 2, 3] & [3, 4, 5] # return an array of elements that are in both arrays
  [1, 2, 3] | [3, 4, 5] # return an array of elements that are in either array
```


## Array elements

Elements can be *any* type of object; literal values or variables, and it can get a little confusing if (and when) arrays are put inside arrays.

```
  my_array = [1, 2, 3, 4, [5, 6, 7]]
```

  - how many elements are in the array? 7? Ruby says five (`my_array.size`)
  - what would you expect to get when you ask for the last item in the array?

Be careful of shovelling an array into an array when you mean to concatenate them.

```
  [1, 2, 3] << [3, 4, 5] # probably not what you wanted...
```


## Making Arrays

With such a bewildering collection of behaviour, you'll not be surprised to learn that there's many ways to create arrays in the first place.

```
  []
  Array.new
  %w(the quick brown fox jumped over the lazy dog)
  "The quick brown fox jumped over the lazy dog".split # .split takes a parameter of a string pattern to split on - it defaults to whitespace
  "The quick brown fox jumped over the lazy dog".split('') # eek!
```


## Handy array methods

You can interrogate arrays to ask them about their contents.

  - `.any?`, `.all?`, `.none?`, `.include?`, `.max`, `.min`

You can manipulate arrays to change their structure.

  - `.flatten`, `.compact`, `.uniq`

You can transform arrays into other objects - probaby most frequently into strings, with a delimiter between former elements.

  - `.join`

Arrays also implement a whole range of "enumerable" functionality, whereby we can iterate the elements and perform operations on each.

This is such important, useful functionality that we'll cover it in a whole dedicated lesson.

  - `.each`

