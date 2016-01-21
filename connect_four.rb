class Field
  attr_accessor :taken_by
  attr_reader :number

  def initialize number
    @number = number
  end

  def taken?
    @taken_by ? true : false
  end

  def parse
    self.taken? ? @taken_by.to_s : ' '
  end
end

class Board
  attr_accessor :fields

  def initialize
    @fields = Array.new(42) { |i| Field.new i }
  end

  def show
    puts (0..6).to_a.join '|'
    6.times do |i|
      puts Array.new(7) { |j| fields[i * j].parse }.join '|'
    end
  end
end

class Game
  def initialize
    @player = "\u274d"
    @board = Board.new
  end

  def greet
    puts 'Let\'s play Connect Four!'
  end

  def ask
    puts "Where do you want to put #{@player}?"
  end

  def get_input
    check input
  end

  def input
    gets.chomp
  end

  def check input
    number = /\d+/.match(input)
    if number
      number.string.to_i % 7
    else
      puts 'Please input a column number'
      get_input
    end
  end

  def result win
    win ? "The winner is #{@player}!" : "It's a draw!"
  end

  def win?
    win = false
    player_fields = @board.fields.select { |field| field.taken_by == @player }
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
    @player == "\u2716" ? @player = "\u274d" : @player = "\u2716"
  end
end
