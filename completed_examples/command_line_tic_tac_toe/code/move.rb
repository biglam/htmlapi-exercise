class Move
  attr_reader :square, :symbol, :player

  def initialize(square, symbol, player)
    @square = square
    @symbol = symbol
    @player = player
  end
end