module Enumerable
  def my_each
    keys = self.keys if self.is_a?(Hash)
    if block_given?
      self.length.times {|index| yield(self[index])} if self.is_a?(Array)
      self.length.times {|index| yield(keys[index],self[keys[index]])} if self.is_a?(Hash)
      self
    else
      self.to_enum(:my_each)
    end
  end

  def my_each_with_index
    keys = self.keys if self.is_a?(Hash)
    if block_given?
      self.length.times {|index| yield(self[index],index)} if self.is_a?(Array)
      self.length.times {|index| yield([keys[index],self[keys[index]]],index)} if self.is_a?(Hash)
      self
    else
      self.to_enum(:my_each)
    end
  end

  def my_select
    
  end
end