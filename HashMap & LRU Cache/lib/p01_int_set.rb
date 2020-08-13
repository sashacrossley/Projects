# Initialize your MaxIntSet with an integer called max to define the range of integers that we're keeping track of.
# Internal structure:
# An array called @store, of length max
# Each index in the @store will correspond to an item, and the value at that index will correspond to its presence (either true or false)
# e.g., the set { 0, 2, 3 } will be stored as: [true, false, true, true]
# The size of the array will remain constant!
# The MaxIntSet should raise an error if someone tries to insert, remove, or check inclusion of a number that is out of bounds.

class MaxIntSet
  attr_accessor :store

  def initialize(max)
    @store = Array.new(max){false}
  end

  def insert(num)
    raise "Out of bounds" if !self.is_valid?(num)
    store[num] = true
  end

  def remove(num)
    @store[num] = false
  end

  def include?(num)
    @store[num] == true
  end

  private

  def is_valid?(num)
    num < @store.length && num >= 0
  end

  def validate!(num)
  end
end

# Now let's see if we can keep track of an arbitrary range of integers. Here's where it gets interesting. Create a brand new class for this one. We'll still initialize an array of a fixed length--say, 20. But now, instead of each element being true or false, they'll each be sub-arrays.

# Imagine the set as consisting of 20 buckets (the sub-arrays). When we insert an integer into this set, we'll pick one of the 20 buckets where that integer will live. That can be done easily with the modulo operator: i = n % 20.

# Using this mapping, which wraps around once every 20 integers, every integer will be deterministically assigned to a bucket. Using this concept, create your new and improved set.

# Initialize an array of size 20, with each containing item being an empty array.
# To look up a number in the set, modulo (%) the number by the set's length, and add it to the array at that index. If the integer is present in that bucket, that's how we know it's included in the set.
# You should fill out the #[] method to easily look up a bucket in the store - calling self[num] will be more DRY than @store[num % num_buckets] at every step of the way!
# Your new set should be able to keep track of an arbitrary range of integers, including negative integers. Test it out.


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    self[num] << num
    true
  end

  def remove(num)
    self[num].delete(num)
  end

  def include?(num)
    self[num].each do |ele|
      return true if ele == num
    end
    false
  end

  private

  def [](num)
    @store[num % num_buckets]
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end
end

# The IntSet is okay for small sample sizes. But if the number of elements grows pretty big, our set's retrieval time depends more and more on an array scan, which is what we're trying to get away from. It's slow.

# Scanning for an item in an array (when you don't know the index) takes O(n) time, because you potentially have to look at every item. So if we're having to do an array scan on one of the 20 buckets, that bucket will have on average 1/20th of the overall items. That gives us an overall time complexity proportional to 0.05n. When you strip out the 0.05 constant factor, that's still O(n). Meh.

# Let's see if we can do better.

# Make a new class. This time, let's increase the number of buckets as the size of the set increases. The goal is to have store.length > N at all times.
# You may want to implement an inspect method to make debugging easier.
# What are the time complexities of the operations of your set implementation?


class ResizingIntSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    resize! if num_buckets == count
    if self.include?(num)
      return false
    else
      self[num] << num
      @count += 1
    end
    true
  end

  def remove(num)
    if self.include?(num)
      self[num].delete(num)
      @count -= 1
    end
  end

  def include?(num)
    self[num].each do |ele|
      return true if ele == num
    end
    false
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
    # old_nums = @store.flatten
    #   (num_buckets).times do
    #     @store << Array.new
    #   end
  end
end
