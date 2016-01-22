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
      expect { field.taken_by = "\u2716" }.to change { field.taken_by }.to "\u2716"
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
        field.taken_by = "\u2716"
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
        it 'returns fields' do
          field.taken_by = "\u2716"
          expect(field.parse).to eql "\u2716"
        end
      end
    end
  end
end

describe Board do
  describe '#fields' do
    context 'on initialize' do
      let(:fields) { subject.fields }

      it 'returns an array' do
        expect(fields).to be_an_instance_of Array
      end

      it 'contains 42 fields' do
        expect(fields).to include a_kind_of Field
        expect(fields.size).to eql 42
      end
    end
  end

  describe '#win?' do
    let(:player) { "\u2716" }

    context 'when win condition not met' do
      it 'returns false' do
        expect(subject.win? player).to be_falsey
      end

      it "doesn't change @win" do
        subject.win? player
        expect(subject.win).to be_falsey
      end
    end

    context 'with four in a row horizontally' do
      before do
        subject.fields[0].taken_by = "\u2716"
        subject.fields[1].taken_by = "\u2716"
        subject.fields[2].taken_by = "\u2716"
        subject.fields[3].taken_by = "\u2716"
      end

      it 'returns true' do
        expect(subject.win? player).to be_truthy
      end

      it "changes @win to true" do
        subject.win? player
        expect(subject.win).to be_truthy
      end
    end

    context 'with four in a row vertically' do
      before do
        subject.fields[2].taken_by = "\u2716"
        subject.fields[9].taken_by = "\u2716"
        subject.fields[16].taken_by = "\u2716"
        subject.fields[23].taken_by = "\u2716"
      end

      it 'returns true' do
        expect(subject.win? player).to be_truthy
      end

      it "changes @win to true" do
        subject.win? player
        expect(subject.win).to be_truthy
      end
    end

    context 'with four in a row diagonally' do
      before do
        subject.fields[0].taken_by = "\u2716"
        subject.fields[8].taken_by = "\u2716"
        subject.fields[16].taken_by = "\u2716"
        subject.fields[24].taken_by = "\u2716"
      end

      it 'returns true' do
        expect(subject.win? player).to be_truthy
      end

      it "changes @win to true" do
        subject.win? player
        expect(subject.win).to be_truthy
      end
    end
  end

  describe '#show' do
    it 'shows board' do
      expect { subject.show }.to output(an_instance_of String).to_stdout
    end
  end
end

describe Player do
  it { is_expected.to have_attributes(current: "\u2716") }

  describe '#switch' do
    it 'switches players' do
      expect { subject.switch }.to change { subject.current }.to("\u274d")
    end
  end
end

describe Turn do
  it 'has attribute field_number' do
    subject.field_number = 2
    expect(subject.field_number).to eql 2
  end
end

describe PlayerInput do
  let(:turn) { Turn.new }
  subject { PlayerInput.new turn}

  describe '#initialize' do
    it 'takes user input and passes it to Turn' do
      expect{ subject }.to change { turn.field_number }.to(a_kind_of Integer)
    end
  end

  describe '#get_input' do
    it 'takes user input and returns number of a column' do
      expect(subject.get_input).to be_a_kind_of Integer
    end
  end

  describe '#check' do
    context 'with a number not greater than 6' do
      it 'returns number of a column' do
        expect(subject.check '1').to eql 1
      end
    end

    context 'with a number greater than 6' do
      it 'returns a valid column number using modulo' do
        expect(subject.check '10').to eql 3
        expect(subject.check '21').to eql 0
      end
    end

    context 'without numeric characters in input' do
      it 'asks for proper input' do
        expect { subject.check 'adef' }.to output(/Please input a column number/).to_stdout
      end
    end

    context 'with numeric and non-numeric chracters in input' do
      it 'finds number and returns valid coumn number' do
        expect(subject.check 'cc21').to eql 0
      end
    end
  end
end

describe Game do
  context 'on initialize' do
    it 'creates new board' do
      expect(subject.board).to be_an_instance_of Board
    end

    it "creates new player" do
      expect(subject.player).to be_an_instance_of Player
    end
  end

  describe '#greet' do
    it 'greets players' do
      expect { subject.greet }.to output("Let's play Connect Four!\n").to_stdout
    end
  end

  describe '#ask' do
    it 'asks user for input' do
      expect { subject.ask }.to output("Where do you want to put \u2716?\n").to_stdout
    end
  end

  describe '#tell_result' do
    context 'there is a draw' do
      it 'returns a draw message' do
        expect(subject.result false).to eql "It's a draw!"
      end
    end

    context "\u2716 wins" do
      it 'returns a win message' do
        subject.player.current = "\u2716"
        expect(subject.result true).to eql "The winner is \u2716!"
      end
    end
  end
end
