class StaticArray
  attr_reader :store

  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    self.store[i]
  end

  def []=(i, val)
    validate!(i)
    self.store[i] = val
  end

  def length
    self.store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, self.store.length - 1)
  end
end

class DynamicArray
  include Enumerable
  attr_accessor :count, :store

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    if i>=self.count
      return nil
    elsif i < 0
      return nil if i < -self.count
      return self.store[(self.count + i)]
    end

    self.store[i]
  end

  def []=(i, val)
    if i >= self.count
      (i - self.count).times {push(nil)}
    elsif i < 0
        return nil if i < -self.count
        return self[(self.count + i)] = val
    end

    if i == self.count
      resize! if capacity == self.count
      self.count += 1
    end

    self.store[i] = val
  end

  def capacity
    self.store.length
  end

  def include?(val)
    each {|value| return true if val == value}
    false
  end

  def push(val)
    resize! if capacity == self.count
    self.store[count] = val
    self.count +=1
    self
  end

  def unshift(val)
    resize! if capacity == self.count
    counter = self.count
    while counter > 0
      self[counter] = self[(counter-1)]
      counter -=1
    end
    self[0] = val
    val
  end

  def pop
    return nil if self.count == 0
    last_ele = self[(count-1)]
    self[(count-1)] = nil
    self.count -= 1
    last_ele
  end

  def shift
    return nil if self.count == 0
    first_item = self[0]
    (0...count).each do |idx|
      self[idx] = self[(idx+1)]
    end
    self[(count-1)] = nil
    self.count -=1
    first_item
  end

  def first
    return nil if self.count == 0
    self[0]
  end

  def last
    return nil if self.count == 0
    self[(count-1)]
  end

  def each
    self.count.times {|idx| yield self[idx]}
    self
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    return false unless length == other.length
    each_with_index { |el, i| return false unless el == other[i] }
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    new_store = StaticArray.new(capacity * 2)
    each_with_index { |el, i| new_store[i] = el }

    self.store = new_store
  end
end

a = DynamicArray.new(3)
p a
a.push(1)
a.push(2)
p a
a.unshift(0)
p a