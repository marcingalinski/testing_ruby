require_relative '../connect_four'
include ConnectFour

describe Field do
  let(:field) { Field.new 32 }
  it 'has attributes: number, state' do
    expect(field).to have_attributes(number: 32, state: nil)
  end

  describe '#initialize' do
    context 'without arguments' do
      it 'raises error' do
        expect { Field.new }.to raise_error ArgumentError
      end
    end
  end

  context 'during the game' do
    it 'changes state' do
      expect { field.state = :red }.to change { field.state }.to :red
    end

    it 'doesn\'t change number' do
      expect { field.number = 1 }.to raise_error NoMethodError
    end
  end
end

describe Board do
  it { is_expected.to respond_to :fields }

  describe '#fields' do
    context 'on initialize' do
      let(:fields) {subject.fields}

      it 'returns an array' do
        expect(fields).to be_an_instance_of Array
      end

      it 'contains 42 fields' do
        expect(fields).to include(a_kind_of Field)
        expect(fields.size).to eql 42
      end
    end
  end
end

describe Game do
  context 'on initialize' do
    it 'creates new board' do
      expect(subject.instance_variable_get(:@board)).to be_an_instance_of Board
    end

    it 'sets player to yellow' do
      expect(subject.instance_variable_get :@player).to eql :yellow
    end
  end

  describe '#win?' do
    before do
      subject.instance_variable_set(:@player, :red)
    end

    context 'when win condition not met' do
      it 'returns false' do
        expect(subject.win?).to be_falsey
      end
    end

    context 'with four in a row horizontally' do
      before do
        subject.instance_variable_get(:@board).fields[0].state = :red
        subject.instance_variable_get(:@board).fields[1].state = :red
        subject.instance_variable_get(:@board).fields[2].state = :red
        subject.instance_variable_get(:@board).fields[3].state = :red
      end

      it 'returns true' do
        expect(subject.win?).to be_truthy
      end
    end

    context 'with four in a row vertically' do
      before do
        subject.instance_variable_get(:@board).fields[2].state = :red
        subject.instance_variable_get(:@board).fields[9].state = :red
        subject.instance_variable_get(:@board).fields[16].state = :red
        subject.instance_variable_get(:@board).fields[23].state = :red
      end

      it 'returns true' do
        expect(subject.win?).to be_truthy
      end
    end

    context 'with four in a row diagonally' do
      before do
        subject.instance_variable_get(:@board).fields[0].state = :red
        subject.instance_variable_get(:@board).fields[8].state = :red
        subject.instance_variable_get(:@board).fields[16].state = :red
        subject.instance_variable_get(:@board).fields[24].state = :red
      end

      it 'returns true' do
        expect(subject.win?).to be_truthy
      end
    end
  end

  describe '#switch' do
    context 'after each turn' do
      it 'switches player' do
        subject.instance_variable_set(:@player, :red)
        expect { subject.switch }.to change { subject.instance_variable_get :@player }
      end
    end
  end
end
