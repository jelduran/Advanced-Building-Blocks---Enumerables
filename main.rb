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
    self.is_a?(Hash) ? new_enumerable = {} : new_enumerable = []
    if block_given?
      self.my_each {|item| new_enumerable.push(item) if yield(item)} if self.is_a?(Array)
      self.my_each {|key,value| new_enumerable[key]=value if yield(key,value)} if self.is_a?(Hash)
      new_enumerable
    else
      self.to_enum(:my_select)
    end
  end

  def my_all? pattern=nil
    if block_given?
      self.my_each {|item| return false unless yield item} if self.is_a?(Array)
      self.my_each {|key,value| return false unless yield [key,value]} if self.is_a?(Hash)
      true
    end
  end

end