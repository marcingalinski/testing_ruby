module ConnectFour
  class Field
    attr_accessor :state
    attr_reader :number

    def initialize number
      @number = number
    end
  end

  class Board
    attr_accessor :fields

    def initialize
      @fields = Array.new(42) { |i| Field.new i }
    end
  end

  class Game
    def initialize
      @player = :yellow
      @board = Board.new
    end

    def win?
      win = false
      player_fields = @board.fields.select { |field| field.state == @player }
      fields_numbers = player_fields.map(&:number).to_set
      offsets = [1, 6, 7, 8]

      fields_numbers.each do |field|
        offsets.each do |offset|
          row = Array.new(4) { |i| field + offset * i }
          win = true if row.to_set.subset? fields_numbers
        end
      end

      win
    end

    def switch
      @player == :red ? @player = :yellow : @player = :red
    end
  end
end
