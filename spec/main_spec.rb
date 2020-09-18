# spec/main_spec.rb

require_relative '../main'

describe Enumerable do
  let(:arr) { [1, 2, 3, 4, 5] }
  describe '#my_each' do
    it 'checks if returns an Enumerator object when no block is given.' do
      expect(arr.my_each).to(satisfy { |output| output.is_a?(Enumerator) })
    end
  end
end
