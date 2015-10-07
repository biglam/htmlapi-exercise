### title

Conditionals and Loops

### topic

### objectives

* To understand how to use conditional operators to control behaviour
* To understand how to use looping constructs to control behaviour

### standards

### materials

### summary

Code-along in IRB to introduce conditional operators and loops. Also moving out of IRB into executing Ruby script files.

### assessment

### follow-up

====================

# Conditional Logic

We sometimes need to evaluate portions of code based on the truthiness or not of a statement (a 'statement' is a small piece of code that expresses some action).

```
  # irb - examples of statements that evaluate to true or false

  4 == 2 + 2
  #=> true

  4 == 2 + 3
  #=> false
```

If a statement is true you may one to pursue one course of action, if it's false, you many want to pursue another.

This is conditional logic. Ruby allows us to write this in a way that sounds a *little* like a "normal" sentence.

```
  if true then "do this" else "do that" end

  unless true then "do this" else "do that" end
```

Note: the 'true' value can be replaced with the statement that evaluates as truthy/falsy, or by a truthy/falsy value in a variable

Aside: we don't normally see these conditionals on one line like this (it's quite hard to read...); instead it's normally presented on multiple lines.

```
  if true
    "do this"
  else
    "do that"
  end
```

But we can also add a conditional statement to the end of single lines of code, as a 'guard'.

```
  "hello" if true
  "hello" if false
```

You will also come across "ternary" operators -- most commonly seen with very simple true/false conditional logic.

```
  true ? "hello" : "bye"
```


## When choices are more complex

'If' statements work very well for one or two conditions, but when there are multiple conditions they can get a bit messy, so instead we can choose to use 'case' statements (in some languages, these are called 'switch' statements).

```
  score = 6
  case score
    when 10
      "genius"
    when 8..9
      "merit"
    when 5..7
      "pass"
    else # default value is optional... without this it would return 'nil'
      "fail"
  end
```

Note: We're reaching the limits of what we want to type in the console, we need to write bigger programs, so we'll need to start working with Ruby files, and executing them in the terminal.

```
  # terminal
  subl what_name.rb
```

```
  # what_name.rb
  puts "What is your name?"
  name = gets
  puts "Hiya, #{name}"
```

```
  # terminal
  ruby what_name.rb
```

Let's take the code from the case statement above and put it in a file to make it reuseable (bear in mind we need to `puts` the output now for users to see it).

```
  # terminal
  subl case_statement.rb
```

```
  # case_statement.rb
  score = 6
  puts case score
    when 10
      "genius"
    when 8..9
      "merit"
    when 5..7
      "pass"
    else # default value is optional... without this it would return nil
      "fail"
  end
```

```
  # terminal
  ruby case_statement.rb
```

Think about what would be needed to alter the program to alter the output? How easy is it to:

  - change the score ranges
  - add more conditions
  - ask user for score as input (rather than hard-coding it as '6')


# Loops

When we need to do the same thing again and again, we loop.

In Ruby we can use any of the following constructs: `for`, `while`, `until`, `loop`

```
  x = 0; until x == 10; puts x += 1; end
  for i in 1..10; puts i; end
```

What happens if the condition is never met?... The code will loop forever, or eventually crash.

```
  x = 0; until x == 10; puts x -= 1; end # ctrl-c to exit ;-)
```

So beware of infinite loops (and stack overflows). Ruby can count Fixnums up to just over 4.5-million-billion (on a 64bit processor), but then automatically converts to Bignum, and just keeps on going until you run out of RAM...


## Playing with loops

Let's write a program that asks a user to guess the answer to a maths question, and loops until they get it right:

```
  # terminal
  subl loop.rb
```

```
  # loop.rb
  my_number = 5
  puts "What number am I thinking of? "
  value = gets.to_i

  until value == my_number
    print "nope... try again: "
    value = gets.to_i
  end

  puts "yes!"
```

What would need to change in the above program to give the user information about whether their guess was too high, or too low? Is it much effort to do that? Why don't we...


## Exiting out of loops

To exit out of loops, and when loops crash, we have some other functionality available to us:

  - break:
    Terminates the most internal loop. Terminates a method with an associated block if called within the block (with the method returning nil).
  - next:
    Jumps to next iteration of the most internal loop. Terminates execution of a block if called within a block (with yield or call returning nil).
  - redo:
    Restarts this iteration of the most internal loop, without checking loop condition. Restarts yield or call if called within a block.
  - retry:
    If retry appears in the iterator, the block, or the body of the for expression, restarts the invocation of the iterator call. Arguments to the iterator is re-evaluated.

So for instance, if we want to loop asking the user for input for ever, *until* they type a particular character ('q'), we could use:

```
  loop do
    print "type something: "
    line = gets.chomp
    break if line.downcase == 'q'
    puts "you typed: #{line}"
  end
```


## More idiomatic Ruby

Loops are a very common programming device, and Ruby support them, but when we get further into Ruby programming, we will use them less, in favour of more idiomatic Ruby constructs. For example:

```
  10.times { |i| puts i }
  1.upto(10) { |i| puts i }
```

The curly brackets are a special syntax of "blocks" - which we'll cover later, but they're a bit easier on the eye than loops, and maybe, more useful and more flexible.

