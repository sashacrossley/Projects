class Node
  attr_reader :key
  attr_accessor :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
  end
end

class LinkedList
include Enumerable
attr_reader :head, :tail
  def initialize
    @head = Node.new
    @tail = Node.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    if empty?
      nil
    else
      self.head.next
    end
  end

  def last
    if empty?
      nil
    else
      self.tail.prev
    end
  end

  def empty?
    self.head.next == self.tail
  end

  def get(key)
    each do |node|
      if node.key == key
        return node.val
      end
    end
    nil
  end

  def include?(key)
    each do |node|
      return true if node.key == key
    end
    false
  end

  def append(key, val)
    new_node = Node.new(key,val)
    self.tail.prev.next = new_node
    new_node.prev = self.tail.prev
    new_node.next = self.tail
    self.tail.prev = new_node
    new_node
  end

  def update(key, val)
    each do |node|
      if node.key == key
        node.val = val 
      end
    end
  end

  def remove(key)
    each do |node|
      if node.key == key
        node.prev.next = node.next
        node.next.prev = node.prev
        node.next = nil
        node.prev = nil
        return node.val
      end
    end
    nil
  end

  def each
    current_node = self.head.next
    until current_node == self.tail
      yield current_node
      current_node = current_node.next
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end

end

