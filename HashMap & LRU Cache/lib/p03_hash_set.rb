# This will be a simple improvement on ResizingIntSet. Just hash every item before performing any operation on it. This will return an integer, which you can modulo by the number of buckets. Implement the #[] method to dry up your code. With this simple construction, your set will be able to handle keys of any data type.

class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    resize! if num_buckets == count
    if self.include?(key)
      return false
    else
      self[key.hash] << key
      @count += 1
    end
    true
  end

  def include?(key)
    self[key.hash].each do |ele|
      return true if ele == key
    end
    false
  end

  def remove(key)
    if self.include?(key)
      self[key.hash].delete(key)
      @count -= 1
    end
  end

  private

  def [](num)
    @store[num % num_buckets]
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end

  def resize!
    old_nums = @store.flatten
    @store = Array.new(num_buckets*2) { Array.new }
    @count = 0
    old_nums.each {|num| insert(num)}
  end
end

a = HashSet.new
a.insert(1)
p a
