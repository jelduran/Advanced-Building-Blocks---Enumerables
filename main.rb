module Enumerable
  def my_each
    keys = self.keys if self.is_a?(Hash)
    if block_given?
      self.length.times {|index| yield(self[index])} if self.is_a?(Array)
      self.length.times {|index| yield(keys[index],self[keys[index]])} if self.is_a?(Hash)
    end
  end
end