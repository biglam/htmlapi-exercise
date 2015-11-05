require 'pry-byebug'
require_relative 'game'
require_relative 'move'

def expect(thing, other_thing=true)
  raise "#{thing} did not equal #{other_thing}" unless thing == other_thing
  print ?.
end

def print_board(game)
  puts(game.board_symbols.each_slice(3).map do |row|
    row.map { |e| e || ' ' }.join(' | ')
  end.join("\n---------\n"))
end


puts `clear`
puts "testing..."

g = Game.new

expect g.moves, []
expect g.board_symbols, [nil, nil, nil, nil, nil, nil, nil, nil, nil]

g.player1 = 'Michael'
g.player2 = 'Dave'

expect g.player1, 'Michael'
expect g.player2, 'Dave'

g.make_move 'Michael', 4

expect g.board_symbols, [nil, nil, nil, nil, 'X', nil, nil, nil, nil]

g.make_move 'Dave', 2
g.make_move 'Michael', 0
g.make_move 'Dave', 1
g.make_move 'Michael', 8

expect g.board_symbols, ['X', 'O', 'O', nil, 'X', nil, nil, nil, 'X']
expect g.finished?
expect g.result, "Michael won!"


puts `clear`

puts "time to play!"

g = Game.new

puts "player 1? "
g.player1 = gets.chomp

puts "player 2? "
g.player2 = gets.chomp


until g.finished?
  puts `clear`
  puts print_board(g)

  puts "#{g.whose_turn}'s move? "

  g.make_move g.whose_turn, gets.to_i
end

puts `clear`
puts print_board(g)

puts g.result


binding.pry;''



