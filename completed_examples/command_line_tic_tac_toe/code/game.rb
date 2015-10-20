class Game
  attr_accessor :player1, :player2
  attr_reader :moves

  def initialize
    @moves = []
  end


  def board
    empty_board.tap do |board|
      moves.each do |move|
        board[move.square] = move if move
      end
    end
  end


  def board_symbols
    board.map { |move| move && move.symbol }
  end


  def make_move(player, square)
    moves << Move.new(square, symbol_for_player(player), player)
  end


  def whose_turn
    return player1 if moves.empty?
    moves.last.player == player1 ? player2 : player1
  end


  def finished?
    winning_game? || drawn_game?
  end


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


  WINNING_LINES = [ [0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6] ]

  private
  def winning_game?
    !!WINNING_LINES.detect do |winning_line|
      %w(XXX OOO).include?(winning_line.map { |e| board_symbols[e] }.join)
    end
  end


  private
  def drawn_game?
    board.all?
  end


  private
  def empty_board
    [nil,nil,nil,nil,nil,nil,nil,nil,nil]
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

end