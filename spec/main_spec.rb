# spec/main_spec.rb

require_relative '../main'

describe Enumerable do
  let(:arr) { [1, 2, 3, 4, 5] }
  let(:target) { [] }
  describe '#my_each' do
    it 'checks if returns an Enumerator object when no block is given.' do
      expect(arr.my_each).to(satisfy { |output| output.is_a?(Enumerator) })
    end

    it 'checks if array is returned when block is given' do
      expect(arr.my_each { |index| index }).to eql(arr)
    end

    it 'checks if method makes an action for every item in the enumerable.' do
      arr.my_each { |i| target.push(i + 5) }
      expect(target).to(satisfy { |t| t == [6, 7, 8, 9, 10] })
    end
  end
end
