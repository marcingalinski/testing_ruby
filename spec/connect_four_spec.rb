require_relative '../connect_four'

describe Field do
  let(:field) { Field.new 32 }
  it 'has attributes: number, taken_by' do
    expect(field).to have_attributes(number: 32, taken_by: nil)
  end

  describe '#initialize' do
    context 'without arguments' do
      it 'raises error' do
        expect { Field.new }.to raise_error ArgumentError
      end
    end
  end

  context 'during the game' do
    it 'changes taken_by' do
      expect { field.taken_by = :red }.to change { field.taken_by }.to :red
    end

    it 'doesn\'t change number' do
      expect { field.number = 1 }.to raise_error NoMethodError
    end
  end

  describe '#taken?' do
    context 'when field is unoccupied' do
      it 'returns false' do
        expect(field.taken?).to be_falsey
      end
    end

    context 'when field is occupied' do
      it 'returns true' do
        field.taken_by = :red
        expect(field.taken?).to be_truthy
      end
    end

    describe '#parse' do
      context 'field is not taken' do
        it 'returns empty string' do
          expect(field.parse).to eql ' '
        end
      end

      context 'field is taken' do
        it 'returns fields owner as a string' do
          field.taken_by = :red
          expect(field.parse).to eql 'red'
        end
      end
    end
  end
end

describe Board do
  let(:board) { Board.new }
  describe '#fields' do
    context 'on initialize' do
      let(:fields) { board.fields }

      it 'returns an array' do
        expect(fields).to be_an_instance_of Array
      end

      it 'contains 42 fields' do
        expect(fields).to include a_kind_of Field
        expect(fields.size).to eql 42
      end
    end
  end

  describe '#show' do
    it 'shows board' do
      expect { board.show }.to output(an_instance_of String).to_stdout
    end
  end
end

describe Game do
  let(:game) {Game.new}
  context 'on initialize' do
    it 'creates new board' do
      expect(game.instance_variable_get :@board).to be_an_instance_of Board
    end

    it 'sets player to yellow' do
      expect(game.instance_variable_get :@player).to eql :yellow
    end
  end

  describe '#greet' do
    it 'greets players' do
      expect { game.greet }.to output("Let's play Connect Four!\n").to_stdout
    end
  end

  describe '#ask' do
    it 'asks user for input' do
      expect { game.ask }.to output("Where do you want to put yellow?\n").to_stdout
    end
  end

  describe '#input' do
    it 'returns string from stdin' do
      expect(game.input).to be_an_instance_of String
    end
  end

  describe '#check' do
    context 'with a number not greater than 6' do
      it 'returns number of a column' do
        expect(game.check '1').to eql 1
      end
    end

    context 'with a number greater than 6' do
      it 'returns a valid column number using modulo' do
        expect(game.check '10').to eql 3
        expect(game.check '21').to eql 0
      end
    end

    context 'without numeric characters in input' do
      it 'asks for proper input' do
        expect { game.check 'adef' }.to output(/Please input a column number/).to_stdout
      end
    end

    context 'with numeric and non-numeric chracters in input' do
      it 'finds number and returns valid coumn number' do
        expect(game.check 'cc21').to eql 0
      end
    end
  end

  describe '#win?' do
    before do
      game.instance_variable_set(:@player, :red)
    end

    context 'when win condition not met' do
      it 'returns false' do
        expect(game.win?).to be_falsey
      end
    end

    context 'with four in a row horizontally' do
      before do
        game.instance_variable_get(:@board).fields[0].taken_by = :red
        game.instance_variable_get(:@board).fields[1].taken_by = :red
        game.instance_variable_get(:@board).fields[2].taken_by = :red
        game.instance_variable_get(:@board).fields[3].taken_by = :red
      end

      it 'returns true' do
        expect(game.win?).to be_truthy
      end
    end

    context 'with four in a row vertically' do
      before do
        game.instance_variable_get(:@board).fields[2].taken_by = :red
        game.instance_variable_get(:@board).fields[9].taken_by = :red
        game.instance_variable_get(:@board).fields[16].taken_by = :red
        game.instance_variable_get(:@board).fields[23].taken_by = :red
      end

      it 'returns true' do
        expect(game.win?).to be_truthy
      end
    end

    context 'with four in a row diagonally' do
      before do
        game.instance_variable_get(:@board).fields[0].taken_by = :red
        game.instance_variable_get(:@board).fields[8].taken_by = :red
        game.instance_variable_get(:@board).fields[16].taken_by = :red
        game.instance_variable_get(:@board).fields[24].taken_by = :red
      end

      it 'returns true' do
        expect(game.win?).to be_truthy
      end
    end
  end

  describe '#tell_result' do
    context 'there is a draw' do
      it 'returns a draw message' do
        expect(game.result false).to eql "It's a draw!"
      end
    end

    context 'red wins' do
      it 'returns a win message' do
        game.instance_variable_set(:@player, :red)
        expect(game.result true).to eql "The winner is red!"
      end
    end
  end

  describe '#switch' do
    context 'after each turn' do
      it 'switches player' do
        game.instance_variable_set(:@player, :red)
        expect { game.switch }.to change { game.instance_variable_get :@player }
      end
    end
  end
end
