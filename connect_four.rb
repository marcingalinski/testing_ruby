class Field
  attr_accessor :state
end

class Board
  attr_accessor :fields
end

class Game
  def initialize
    @board = Board.new
  end
end
