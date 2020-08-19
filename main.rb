module Enumerable
  def my_each
    keys = self.keys if self.is_a?(Hash)
    if block_given?
      self.length.times {|index| yield(self[index])} if self.is_a?(Array)
    end
  end
end