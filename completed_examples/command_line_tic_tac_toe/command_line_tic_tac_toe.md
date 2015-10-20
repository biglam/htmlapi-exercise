# Command Line TicTacToe

We're going to spend some time reviewing Object Oriented Programming by playing a game of naughts and crosses. A fairly simple game, right? So the code shouldn't be too hard! ;-)


## Design

When we start to code, we need to *stop*. And just *think* about our app... what should it do when it's finished? If you just dive in to start coding, you might find there are rocks just below the surface. Do some planning to make your experience safer!

Well... I suppose we want to be able to create new games for two players, and have them alternate placing their symbols on a 3x3 board until the game is finished.

Not so bad. Can we determine what "finished" means? How does a game finish?

  - When there's a winner (what does "winning mean"?) - three of the same symbol in a row vertically, horizontally, or diagonally
  - Or when there's a draw - no more spaces on the board

Now we know what our app should do, we make a list of the functionality:

  - Make new game
  - Assign players
  - Make move
  - Determine if game's finished
  - If it's finished, determine the result

Whoop! Now we have a plan, we can get going.


## Coding

We'll start by creating a new directory, and main file to co-ordinate our app.

```
  # terminal
  mkdir ttt
  cd ttt
  touch main.rb
  subl .
```

We can then start coding away, but a little voice in our head tells us to be very thorough, and make sure our code is doing what we expect it to be doing. After we create a new game, we'll check that the object is the class we expect it to be (seems OTT right? we'll see...)

```
  # main.rb
  require 'pry-byebug'

  puts `clear`
  puts "playing TTT..."

  g = TTTGame.new

  puts g.class.name == "Game" # We'd expect this to be `true` right?
```

However when we run it, we get an (obvious, maybe) error that `Game` is an uninitialized constant. How do we initialize it? We need to create a `Game` class in a `ttt_game.rb` file and require that into our code.

```
  # terminal
  touch ttt_game.rb
```

```
  # ttt_game.rb
  class TTTGame
  end
```

```
  # main.rb
  require_relative 'game'
```

Yay! Now it works! :-)

So we can carry on adding functionality, safe in the knowledge that if the type of object that gets returned from instanciating a new Game is anything other than `Game`, we'll get an error/warning from our code.

It's almost like having some kind of automated testing available to us...</sarcasm>


## More functionality

So we have ticked off the first of our functional requirements, but we might decide now to add some more. What sort of things should we be able to ask our Game about? If we are expecting to be able to make moves at some point, should we expect that a game would know what all the moves so far are? If so, what would that look like when we create the new game first of all?

So how about expecting that when we ask a brand new Game for it's moves, we should get an empty array back?

This reflection on the functionality of our app is the sort of thing we should be trying to do before we set finger to keyboard. And to ensure we're doing it like that, let's write the code that would check our expectation *before* we write the code that provides the functionality.

```
  # main.rb
  puts g.moves == [] # We'd expect this to be `true` too when/if everything were working
```

Running our code now gives us an error that `.moves` is an undefined method. So we really aught to define it before taking a break and getting ourselves a coffee.

```
  # ttt_game.rb
  attr_reader :moves
```

This stops the error about the undefined method, but now the code is printing `false`. To make it `true` as we'd hope, we need to initialize the game's `@moves` instance variable as an empty array.

```
  # ttt_game.rb
  def initialize
    @moves = []
  end
```

This is a *tiny* piece of functionality, but what we're doing is building our code from these tiny pieces, each of which has a line of code testing that it does what expects. The code and lines of test move forward hand-in-hand, like a climber attaching pitons as they move up a route, so that any mistakes later can be caught .


## Refactoring

"Refactoring" is a fantastic word - almost everyone that uses it uses it wrong.

It *means* changing code to make it "better" by some measure (brevity, clarity, idiom, personal preference, whatever) but *without* changing *any* functionality at all.

If we look at our code, is there anything that might be jumping out at us about how we could improve what's there, without altering anything about the end result (the return values from methods).

The one thing that's jumping out at me, is the two outputs of `true`, which aren't really functionality of the app, but part of the code we're using to making sure everything's working correctly. As we write more code, we'll anticipate writing lots more of these little tests. It would be nice to change them to be DRY and unobtrusive, and to *really* let us know when a test fails.

Note: Refactoring in TDD means applying the same principles of whatever "good code" means to your tests too; not *just* to your objects.

```
  # main.rb
  def expect(thing, other_thing=true)
    raise "#{thing} did not equal #{other_thing}" unless thing == other_thing
    print ?. # maybe we still want *some* output to indicate when a test is run and passes, or maybe delete this line? Your choice.
  end
```

```
  # main.rb
  expect g.class.name, "Game" # We'd expect this to be `true` right?
```

```
  # main.rb
  expect g.moves, [] # We'd expect this to be `true` too
```


## Game on!

The next piece of functionality is the requirement to add players. What would you expect to be able to do for this to work?

```
  # main.rb
  g.player1 = 'Michael'
  g.player2 = 'Dave'

  expect g.player1, 'Michael'
  expect g.player2, 'Dave'
```

So fix the errors... how can we enable the Game to have `.player1` and `.player2` 'get' and 'set' methods? (load of ways! The easiest, and simplest, in Ruby would probably be to add accessors)

```
  # ttt_game.rb
  attr_accessor :player1, :player2
```

Once that's working, we can cross out the requirement in the functionality list.


## Move along

Now we get to the fun bit. How are players going to make moves? Or rather, what do we imagine would be the end result? We probably want to ask the game to make a move for a given player into a given grid square.

Aside: But what numbering shall we use for our squares? Numbering from 1..9 seems sensible for a human:

```
  # ascii art
   1 | 2 | 3
  ---|---|---
   4 | 5 | 6
  ---|---|---
   7 | 8 | 9
```

But what might make sense for a computer? Would this be 'better' for any reason?

```
  # ascii art
   0 | 1 | 2
  ---|---|---
   3 | 4 | 5
  ---|---|---
   6 | 7 | 8
```

If we number the squares from zero, they will fit nicely to being represented as an array should we need to do that...

```
  # main.rb
  g.make_move 'Michael', 4
```

What would the `.moves` array look like now? Maybe it would be a collection of `Move` objects... so we should assert that with our expectation.

```
  # main.rb
  expect g.moves.last.class.name, 'Move'
```

```
  # console
  touch move.rb
```

```
  # move.rb
  class Move
  end
```

```
  # ttt_game.rb
  def make_move(player, square)
    moves << Move.new
  end
```

This passes the tests, but doesn't really finish the functionality. We need to store more information in the Move when we create it. What sort of stuff should an individual move 'know' about itself.

```
  # main.rb
  expect g.moves.last.player, 'Michael'
  expect g.moves.last.square, '4'
  expect g.moves.last.symbol, 'X'
```

```
  # move.rb
  attr_reader :square, :symbol, :player

  def initialize(square, symbol, player)
    @square = square
    @symbol = symbol
    @player = player
  end
```

```
  # ttt_game.rb
  def make_move(player, square)
    Move.new(square, 'X', player)
  end
```

Working! But can you spot the (deliberate) mistake ;-)


## Magic Numbers

Magic numbers are a concept in programming of a hard-coded value that means "something", but it's not always clear from the value itself what that thing is.

As a general principle they are bad, or rather 'BAD'.

However, in TDD (for that is what we're doing!), they can be used as a temporary placeholder to check that tests and code are working fine together, to build code up line by line.

As it stands, our code is working... right?

Unless we add another test, which describes what we'd expect to happen next.

```
  # main.rb
  g.make_move 'Dave', 2
  expect g.moves.last.player, 'Dave'
  expect g.moves.last.square, '2'
  expect g.moves.last.symbol, 'O'
```

So our magic number is now failing us - we have an 'X' being returned when we now see we sometimes need a 'O'.

So we need some way of working out what the symbol is for a given player.

```
  # ttt_game.rb
  def make_move(player, square)
    moves << Move.new(square, symbol_for_player(player), player)
  end

  private
  def symbol_for_player(player)
    case player
    when player1
      ?X
    when player2
      ?O
    else
      raise "who?! that's not one of my players!"
    end
  end
```

The 'else' is not necessary, and strictly, we'd not written a test for it, so we're very naughty for adding it.


## Extra functionality?

Has anything we've just done rung any bells in your head about extra functionality we might need at some point? When you think of something, you should add it to the list: it's easy to cross it out later, but harder to wrack your brains in two hours trying to remember what that important thing was that popped into your head earlier.

What do you think should happen if one player tries to make two moves in a row? Or what if the square is already taken? Or the game is already won?

Add these to the list, because we might not get the functionality written today, but you might need to do them tomorrow (IRL).


## Are we there yet?

The next of the original pieces of functionality was to be able to determine whether a game was finished. Hopefully... if we're getting into the swing of how we're developing this, we can anticipate what the next bit of code might look like.

Yup... go into `main.rb` and add some expectations for what you want the end result to look like.

```
  # main.rb
  expect g.finished?, false
  g.make_move 'Michael', 0
  g.make_move 'Dave', 1
  g.make_move 'Michael', 8
  expect g.finished?
```

You might be tempted to write another expectation for the last, related requirement of determining the result, but let's just take one step at a time to not get ourselves tied up (and `.finished?` might be more complicated than we anticipate...).

But we determined earlier what a finished game is, so we can create a method that checks whether it's a win, or a draw.

```
  # ttt_game.rb
  def finished?
    winning_game? || drawn_game?
  end

  private
  def winning_game?
    # is there a winner?
  end

  private
  def drawn_game?
    # is it a draw?
  end
```

Our current conundrum illustrates the crux of TDD, we now know where we want to get to, we have a goal, but we have no idea what to put into those methods. But the glorious thing is that *it doesn't matter*... put anything in there that passes the test, then change it to be 'better' later.

The easiest way of telling if it's a draw is to see if there's nine moves, right? Or can you suggest any easier or better ways?

```
  private
  def drawn_game?
    moves.size == 9
  end
```

To tell a winning game it's a bit harder. We need to look at all of the moves squares, and see if there are matching symbols on any of the winning lines. We have numbered the squares from zero, so we can create an array of the moves in order of their position on the board, and then interrogate that to find what symbol is in each square.

```
  private
  def board
    empty_board.tap do |board|
      moves.each do |move|
        board[move.square] = move if move
      end
    end
  end

  private
  def empty_board
    [nil,nil,nil,nil,nil,nil,nil,nil,nil]
  end
```

Note: Because these are private methods, we don't *need* to write tests for them (they're not exposed to the world through the object's interface). If we wanted to make them public to use them outside the class, then we *should* write tests before publicising them...


```
  # main.rb
  expect g.board_symbols, ['X', 'O', 'O', nil, 'X', nil, nil, nil, 'X']
```

```
  # ttt_game.rb
  def board_symbols
    board.map { |move| move && move.symbol }
  end
```

But let's get on with our functionality. We might need to perform whatever rituals help us think about things (take a shower, eat a pizza, hang from the door frame by your finger tips...) but at least we have our tests to keep us focussed on what *one thing* we need to get working... this `.winning_game?` method.

```
  # ttt_game.rb
  WINNING_LINES = [ [0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6] ]

  private
  def winning_game?
    !!WINNING_LINES.detect do |winning_line|
      %w(XXX OOO).include?(winning_line.map { |e| board_symbols[e] }.join)
    end
  end
```

Was that too fast? Shall we go over it line by line?

Well first of all we define what the 'lines' on our board look like; which indices are straight lines for us. There are eight of them, so we put them in an array - three horizontal, three vertical, and two diagonals.

Then we loop over each of the winning lines; looking at them one at a time to see if our board has a 'win' on that line. How can we tell that?

We have to look at every square on the line, and see if every square has the same symbol in it - either three 'X' or three 'O'.

If we do find one winning line, we don't need to carry on looking, which is why we are using `.detect` - we get a return value for the first truthy evaluation of the block.

*phew*!


## Time for coffee?

Sure. A nice effect of this step-by step process is that you can break *any time* you
like. Your code will be in only one of two states:

  1. You'll be half-way through making a test pass (but you'll have a failing test reminding you what you are working on)
  2. Your code will be passing all it's tests, and you'll be pondering which bit of new functionality from your list to write a test for next.

So if you want a break, take one!


## Who won?

```
  # main.rb
  expect g.result, "Michael won!"
```

```
  # ttt_game.rb
  def result
    case
    when drawn_game?
      "It is a draw!"
    when winning_game?
      "#{moves.last.player} won!"
    else
      "It's still in progress"
    end
  end
```


## Let's play!

All our testing has been of hard-coded values in our main file, but we also want to be able to play interactively.

We'll add one helper method to our main file (to show a visualiation of our board), and then a bunch of looping and user interface like we're used to.


```
  # main.rb
  def print_board(g)
    puts(g.board_symbols.each_slice(3).map do |row|
      row.map { |e| e || ' ' }.join(' | ')
    end.join("\n---------\n"))
  end


  puts `clear`
  puts "time to play!"
  g = Game.new

  puts "What's player 1's name? "
  g.player1 = gets.chomp

  puts "What's player 2's name? "
  g.player2 = gets.chomp

  until g.finished?
    puts `clear`
    puts print_board(g)
    puts "Where's #{g.whose_turn}'s move? "
    g.make_move g.whose_turn, gets.to_i
  end

  puts `clear`
  puts print_board(g)
  puts g.result
```

Now... let's do the same for a nice game of chess... ;-)



