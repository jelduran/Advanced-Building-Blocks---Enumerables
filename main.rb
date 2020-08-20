module Enumerable
  def my_each
    keys = self.keys if is_a?(Hash)
    if block_given?
      length.times { |index| yield(self[index]) } if is_a?(Array)
      length.times { |index| yield(keys[index], self[keys[index]]) } if is_a?(Hash)
      self
    end
    to_enum(:my_each)
  end

  def my_each_with_index
    keys = self.keys if is_a?(Hash)
    if block_given?
      length.times { |index| yield(self[index], index) } if is_a?(Array)
      length.times { |index| yield([keys[index], self[keys[index]]], index) } if is_a?(Hash)
      self
    end
    to_enum(:my_each_with_index)
  end

  def my_select
    new_enumerable = empty_enum
    if block_given?
      my_each { |item| new_enumerable.push(item) if yield(item) } if is_a?(Array)
      my_each { |key, value| new_enumerable[key] = value if yield(key, value) } if is_a?(Hash)
      new_enumerable
    end
    to_enum(:my_select)
  end

  def my_all?(pattern = nil)
    if block_given?
      my_each { |item| return false unless yield item } if is_a?(Array)
      my_each { |key, value| return false unless yield [key, value] } if is_a?(Hash)
      true
    end
    my_all? { |item| item =~ pattern } if pattern.is_a?(Regexp)
    my_all? { |item| item }
  end

  def my_any?(pattern = nil)
    if block_given?
      my_each { |item| return true if yield item } if is_a?(Array)
      my_each { |key, value| return true if yield [key, value] } if is_a?(Hash)
      false
    end
    my_any? { |item| item =~ pattern } if pattern.is_a?(Regexp)
    my_any? { |item| item }
  end

  def my_none?(pattern = nil)
    if block_given?
      my_each { |item| return false if yield item } if is_a?(Array)
      my_each { |key, value| return false if yield [key, value] } if is_a?(Hash)
      true
    end
    my_none? { |item| item =~ pattern } if pattern.is_a?(Regexp)
    my_none? { |item| item }
  end

  def my_count(search = nil)
    counter = 0
    if block_given?
      my_each { |item| counter += 1 if yield(item) } if is_a?(Array)
      my_each { |key, value| counter += 1 if yield([key, value]) } if is_a?(Hash)
      counter
    end
    my_count { |item| item == search } if search
    length
  end

  def my_map(proc = nil)
    map = []
    if proc.is_a?(Proc)
      my_each { |item| map << proc.call(item) } if is_a?(Array)
      my_each { |key, value| map << proc.call([key, value]) } if is_a?(Hash)
      map
    end
    if block_given?
      my_each { |item| map << yield(item) } if is_a?(Array)
      my_each { |key, value| map << yield([key, value]) } if is_a?(Hash)
      map
    end
    to_enum(:my_map)
  end

  def my_inject(memo = nil, &_sym)
    my_each { |item| memo = item ? memo.nil? : memo = yield(memo, item) } if is_a?(Array)
    if is_a?(Hash)
      my_each do |key, value|
        item = [key, value]
        memo = item ? memo.nil? : memo = yield(memo, [key, value])
      end
    end
    memo
  end

  def empty_enum
    empty_hash = {}
    empty_hash ? is_a?(Hash) : []
  end

  def multiply_els
    my_inject(&:*)
  end
end
