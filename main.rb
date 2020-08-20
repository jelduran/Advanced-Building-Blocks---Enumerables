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
    elsif pattern
      self.my_all? {|item| pattern===item}
    else
      self.my_all? {|item| item}
    end
  end

  def my_any? pattern=nil
    if block_given?
      self.my_each {|item| return true if yield item} if self.is_a?(Array)
      self.my_each {|key,value| return true if yield [key,value]} if self.is_a?(Hash)
      false
    elsif pattern
      self.my_any? {|item| pattern===item}
    else
      self.my_any? {|item| item}
    end
  end

  def my_none? pattern=nil
    if block_given?
      self.my_each {|item| return false if yield item} if self.is_a?(Array)
      self.my_each {|key,value| return false if yield [key,value]} if self.is_a?(Hash)
      true
    elsif pattern
      self.my_none? {|item| pattern===item}
    else
      self.my_none? {|item| item}
    end
  end

  def my_count search=nil
    counter = 0
    if block_given?
      self.my_each {|item| counter+=1 if yield(item)} if self.is_a?(Array)
      self.my_each {|key,value| counter+=1 if yield([key,value])} if self.is_a?(Hash)
      counter
    elsif search
      self.my_count {|item| item==search}
    else
      self.length
    end
  end

  def my_map
    map = []
    if block_given?
      self.my_each {|item| map << yield(item)} if self.is_a?(Array)
      self.my_each {|key,value| map << yield([key,value])} if self.is_a?(Hash)
      map
    else
      self.to_enum(:my_map)
    end
  end

  def my_inject(memo=nil,&sym)

  end

end
