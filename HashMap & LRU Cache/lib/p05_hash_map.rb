# So here again is a summary of how you use our hash map:

# Hash the key, mod by the number of buckets (implement the #bucket method first for cleaner code - it should return the correct bucket for a hashed key)

# To set, insert a new node with the key and value into the correct bucket. (You can use your LinkedList#append method.) If the key already exists, you will need to update the existing node.

# To get, check whether the linked list contains the key you're looking up.
# To delete, remove the node corresponding to that key from the linked list.
# Finally, let's make your hash map properly enumerable. You know the drill. Implement #each, and then include the Enumerable module. Your method should yield [key, value] pairs.

# Also make sure your hash map resizes when the count exceeds the number of buckets! In order to resize properly, you have to double the size of the container for your buckets. Having done so, enumerate over each of your linked lists and re-insert their contents into your newly-resized hash map. If you don't re-hash them, your hash map will be completely broken. Can you see why?


require_relative 'p04_linked_list'

class HashMap
  include Enumerable
  attr_accessor :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    return false if self.store[key.hash % num_buckets].nil?

    self.store[key.hash % num_buckets].each do |node|
      if node.key == key
        return true
      end
    end
    false
  end

  def set(key, val)
    resize! if num_buckets == count
    if self.include?(key)
      self.store[key.hash % num_buckets].update(key,val)
    else
      self.store[key.hash % num_buckets].append(key,val)
      self.count += 1
    end
    true
  end

  def get(key)
    self.store[key.hash % num_buckets].get(key)
  end

  def delete(key)
    if include?(key)
      self.store[key.hash % num_buckets].remove(key)
      self.count -= 1
    end
    nil
  end

  def each
    self.store.each do |bucket|
      bucket.each do |node|
        yield [node.key, node.val]
      end
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    old_store = self.store
    self.store = Array.new(num_buckets*2) { LinkedList.new }
    self.count = 0
    old_store.each do |bucket|
      bucket.each {|node|set(node.key, node.val)}
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
  end
end
