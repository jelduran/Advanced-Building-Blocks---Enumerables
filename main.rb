module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    enum = to_a
    enum.length.times { |index| yield(enum[index]) }
    self
  end

  def my_each_with_index
    return to_enum(:my_each) unless block_given?

    enum = to_a
    enum.length.times { |index| yield(enum[index], index) }
    self
  end

  def my_select
    new_enumerable = []
    return to_enum(:my_select) unless block_given?

    is_a?(Array) ? my_each { |item| new_enumerable.push(item) if yield(item) } : new_enumerable = {}
    my_each { |key, value| new_enumerable[key] = value if yield(key, value) } if is_a?(Hash)
    new_enumerable
  end

  def my_all?(pattern = nil)
    return my_all? { |item| item } unless block_given?

    if pattern
      case pattern.class.to_s
      when 'Class' then my_all? { |item| item.is_a?(pattern) }
      when 'Regexp' then my_all? { |item| item =~ pattern }
      else false
      end
    else
      my_each_with_index { |item| return false unless yield item }
      true
    end
  end

  def my_any?(pattern = nil)
    return my_any? { |item| item } unless block_given?

    if pattern
      case pattern.class.to_s
      when 'Class' then my_any? { |item| item.is_a?(pattern) }
      when 'Regexp' then my_any? { |item| item =~ pattern }
      else false
      end
    else
      my_each_with_index { |item| return true if yield item }
      false
    end
  end

  def my_none?(pattern = nil)
    return my_none? { |item| item } unless block_given?

    if pattern
      case pattern.class.to_s
      when 'Class' then my_none? { |item| item.is_a?(pattern) }
      when 'Regexp' then my_none? { |item| item =~ pattern }
      else false
      end
    else
      my_each_with_index { |item| return false if yield item }
      true
    end
  end

  def my_count(search = nil)
    counter = 0
    return length unless block_given?

    if search
      my_count { |item| item == search }
    else
      my_each_with_index { |item| counter += 1 if yield(item) }
      counter
    end
  end

  def my_map(proc = nil)
    map = []
    return to_enum(:my_map) unless block_given?

    if proc.is_a?(Proc)
      my_each_with_index { |item| map << proc.call(item) }
    else
      my_each_with_index { |item| map << yield(item) }
    end
    map
  end

  def my_inject(memo = nil, &_sym)
    my_each_with_index { |item| memo = memo.nil? ? item : yield(memo, item) }
    memo
  end

  def multiply_els
    my_inject(&:*)
  end
end
