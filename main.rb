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
    new_enumerable = []
    if block_given?
      is_a?(Array) ? my_each { |item| new_enumerable.push(item) if yield(item) } : new_enumerable = {}
      my_each { |key, value| new_enumerable[key] = value if yield(key, value) } if is_a?(Hash)
      return new_enumerable
    end
    to_enum(:my_select)
  end

  def my_all?(pattern = nil)
    if block_given?
      my_each_with_index { |item| return false unless yield item }
      return true
    end
    if pattern
      case pattern.class.to_s
      when 'Class' then my_all? { |item| item.is_a?(pattern) }
      when 'Regexp' then my_all? { |item| item =~ pattern }
      else false
      end
    else
      my_all? { |item| item }
    end
  end

  def my_any?(pattern = nil)
    if block_given?
      my_each_with_index { |item| return true if yield item }
      return false
    end
    if pattern
      case pattern.class.to_s
      when 'Class' then my_any? { |item| item.is_a?(pattern) }
      when 'Regexp' then my_any? { |item| item =~ pattern }
      else false
      end
    else
      my_any? { |item| item }
    end
  end

  def my_none?(pattern = nil)
    if block_given?
      my_each_with_index { |item| return false if yield item }
      return true
    end
    if pattern
      case pattern.class.to_s
      when 'Class' then my_none? { |item| item.is_a?(pattern) }
      when 'Regexp' then my_none? { |item| item =~ pattern }
      else false
      end
    else
      my_none? { |item| item }
    end
  end

  def my_count(search = nil)
    counter = 0
    if block_given?
      my_each_with_index { |item| counter += 1 if yield(item) }
      return counter
    end
    my_count { |item| item == search } if search
    length
  end

  def my_map(proc = nil)
    map = []
    if proc.is_a?(Proc)
      my_each_with_index { |item| map << proc.call(item) }
      return map
    end
    if block_given?
      my_each_with_index { |item| map << yield(item) }
      return map
    end
    to_enum(:my_map)
  end

  def my_inject(memo = nil, &_sym)
    my_each_with_index { |item| memo = memo.nil? ? item : yield(memo, item) }
    memo
  end

  def multiply_els
    my_inject(&:*)
  end
end
