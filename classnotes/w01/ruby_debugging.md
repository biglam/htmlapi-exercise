# Debugging

This is going to be useful all the way through the course -- it's not that difficult but very powerful and will help save you time.

question:

  - Who sat down for their homework - started typing. Didn't stop, ran their code and it all worked perfectly?

(no-one, probably)

What sort of errors did you get?

  - syntax errors and structural
  - undefinied method or local variable
  - could not convert string into fixednum

After you got the program running did it give you the right answer?

(Some people may have had 'working code' - ie. it didn't crash - but not the correct answers)

Debugging is the process of working through those errors and removing 'bugs' from the system.


# Debugging methods

What opportunities and methods do we have of debugging?

  - Guesswork (intuition?!)
  - Process of elimination
  - Testing (manual and automatic) (irb)
  - Console output
  - Rubber duck
  - Breakpoint... someone has built a tool to help us out.

"Pry" is a debugging tool that allows us to add 'breakpoints' into our code and inspect it while it's running.

[http://pryrepl.org/]()
[https://github.com/deivid-rodriguez/pry-byebug]()

```
  gem install pry pry-byebug pry-doc
```

After you've installed the gem, you may need to rehash (if you're running rbenv):

```
  rbenv rehash
```

Pry is also a direct replacement for "irb". Let's give it a try:

```
  # terminal
  pry

  # pry
  2 + 2
  => 4
```

Pry makes output a bit prettier than "irb", by using colour, and by laying things out better.

One of pry's best features is its ability to freeze the execution of a file of ruby commands, letting you take a peek inside the running program (this is called "runtime invocation").

One way of understanding how the new code works is to step through it one line at a time.

First of all, we have to "require" a gem somewhere in our code in order to use it in our program.

```
  require 'pry-byebug'
```

To pause the execution of a Ruby program, we can put the command `binding.pry` on a line in our code; it is our breakpoint. Our code will stop here when we run it, allowing us to interrogate the current value of variables, and step through the rest of the code one line at a time in the console.

```
  # functions.rb
  require 'pry-byebug'

  until value == my_number

    binding.pry

    print "nope... try again: "
    value = gets.to_i
  end
```

To view all the variables available to you, Pry behaves a little like the shell - and it gives you commands that should sound familiar:

```
  ls
```

This shows all our local variables. We didn't necessarily define them all, some were created automatically, like `\_file\_`.

To see a list of all the local variables (we created) add a `-l`  flag (for local).

```
  ls -l
```

We can run the line of code by entering the command `next`. All of the code on the current line of code will be evaluated, and Pry will move on to the next line and pause execution again waiting for your input.

*NOTE*: if your terminal window is too small for the snippet to display entirely, you will be in the Unix shell "pager" (if you haven't changed it, it should be the program "less") application. You can scroll with the arrow keys and page up/down. You will need to press "q" to exit from this scrolling.

When you're finished investigating your code, you can leave Pry with the commands `exit` or `continue`. The program will run normally (until it hits another `binding.pry` command).


### Other tips

On some lines of code you will have calls to other methods/functions, and you might want to investigate what those methods are doing line-by-line. To do so, instead of going to the `next` line, we can `step` into the method call, and Pry will take us there.

While you're 'stepped' into methods, type `finish` to "bubble" back up to the calling line of code.

If you got lost and cannot remember where you are in your program, `whereami` will draw the code snippet again.

If all else fails, three exclamation marks are the "ejector seat" to completely leave Pry *and* exit the program you're running. Type `!!!` and you'll be back at a terminal prompt.

"Pry" and "pry-byebug" have a lot more features (especially pry) than we've covered in class today.

Check out the Pry [GitHub repo](https://github.com/pry/pry) and their [website](http://pryrepl.org/) for additional information.


