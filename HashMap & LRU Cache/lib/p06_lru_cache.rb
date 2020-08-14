# Let's say we're building an LRU cache that's going to cache the values of the perfect squares. So our LRU cache will store a @prc, which in this case will be Proc.new { |x| x ** 2 }. If we don't have the value of any number's square, we'll use this Proc to actually compute it. But we don't want to compute it for the same number twice, so after I compute anything, I'll store it in my LRU cache. But if my LRU Cache gets an input that doesn't exist in the cache, it'll compute it using the Proc.

# Now build your LRU cache. Every time you add a new key-value pair to your cache, you'll take two steps.
# First, look to see if the key points to any node in your hash map. If it does, that means that the item exists in your cache. Before you return the value from the node though, move the node to the very end of the list (since it's now the most recently used item).
# Say the key isn't in your hash map. That means it's not in your cache, so you need to compute its value and then add it. That has two parts.
# First, you call the proc using your key as input; the output will be your key's value. Append that key-value pair to the linked list (since, again, it's now the most recently used item). Then, add the key to your hash, along with a pointer to the new node. Finally, you have to check if the cache has exceeded its max size. If so, call theeject! function, which should delete the least recently used item so your LRU cache is back to max size.
# Hint: to delete that item, you have to delete the first item in your linked list, and delete that key from your hash. Implemented correctly, these should both happen in O(1) time.


require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache

  attr_reader :max, :prc

  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if self.map[key]
      update_node!(self.map[key])
      self.map[key]
    else
      calc!(key)
    end
  end

  def to_s
    'Map: ' + @map.to_s + '\n' + 'Store: ' + @store.to_s
  end

  private

  attr_reader :map, :store
  def calc!(key)
    val = self.prc.call(key)
    self.map[key] = self.store.append(key,val)

    if count > self.max
      eject!
    end
    val
    # suggested helper method; insert an (un-cached) key
  end

  def update_node!(node)
    self.store.remove(node.key)
    self.map[node.key] = self.store.append(node.key, node.val)
    # suggested helper method; move a node to the end of the list
  end

  def eject!
    first_node = self.store.first
    self.store.remove(first_node.key)
    self.map.delete(first_node.key)
    nil
  end
end
