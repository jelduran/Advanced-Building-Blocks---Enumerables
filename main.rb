module Enumerable
  def my_each
    keys = self.keys if self.is_a?(Hash)
    if block_given?
    end
  end
end