require 'set'

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
    self.taken? ? @taken_by : ' '
  end
end

class Board
  attr_accessor(:fields, :win)

  def initialize
    @fields = Array.new(42) { |i| Field.new i }
    @win = false
  end

  def show
    puts (0..6).to_a.join '|'
    6.times do |i|
      puts Array.new(7) { |j| fields[i * 7 + j].parse }.join '|'
    end
  end

  def win? player
    player_fields = @fields.select { |field| field.taken_by == player }
    fields_numbers = player_fields.map(&:number).to_set
    offsets = [1, 6, 7, 8]

    to_check_with_1 = fields_numbers.reject do |n|
      (4..6).include? n % 7
    end

    to_check_with_1.each do |field|
      row = Array.new(4) { |i| field + i }
      return @win = true if row.to_set.subset? fields_numbers
    end

    to_check_with_6 = fields_numbers.reject do |n|
      (0..3).include? n % 7
    end

    to_check_with_6.each do |field|
      row = Array.new(4) { |i| field + i * 6 }
      return @win = true if row.to_set.subset? fields_numbers
    end

    to_check_with_7 = fields_numbers

    to_check_with_7.each do |field|
      row = Array.new(4) { |i| field + i * 7 }
      return @win = true if row.to_set.subset? fields_numbers
    end

    to_check_with_8 = to_check_with_1

    to_check_with_8.each do |field|
      row = Array.new(4) { |i| field + i * 8 }
      return @win = true if row.to_set.subset? fields_numbers
    end

    return false
  end
end

class Player
  attr_accessor :current

  def initialize
    @current = "\u2716"
  end

  def switch
    @current = @current == "\u2716" ? "\u274d" : "\u2716"
  end
end

class Turn
  attr_accessor :field_number

  def initialize game
    @game = game
    PlayerInput.new self
    mark_field
  end

  def mark_field
    if @game.board.fields[@field_number].taken?
      ask_for_another
    else
      find_empty_field
    end
  end

  def ask_for_another
    puts "Choose another column. This one is full!"
    PlayerInput.new self
    mark_field
  end

  def find_empty_field
    row = 6

    while row > 0
      row -= 1
      field = @game.board.fields[row * 7 + @field_number]
      unless field.taken?
        field.taken_by = @game.player.current
        break
      end
    end
  end
end

class PlayerInput
  def initialize turn
    turn.field_number = get_input
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
end

class Game
  attr_accessor(:board, :player)

  def initialize
    @player = Player.new
    @board = Board.new
    greet
    42.times do
      @player.switch
      ask
      @board.show
      Turn.new self
      break if @board.win? @player.current
    end
    @board.show
    puts result @board.win
  end

  def greet
    puts 'Let\'s play Connect Four!'
  end

  def ask
    puts "Where do you want to put #{@player.current}?"
  end

  def result win
    win ? "The winner is #{@player.current}!" : "It's a draw!"
  end
end

Game.new
