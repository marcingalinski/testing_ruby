require_relative '../connect_four'
include ConnectFour

describe Field do
  it { is_expected.to respond_to(:state) }
end

describe Board do
  it { is_expected.to respond_to(:fields) }
end

describe Game do
  it 'creates new board on initialize' do
    expect(subject.instance_variable_get(:@board)).to be_an_instance_of(Board)
  end
end
