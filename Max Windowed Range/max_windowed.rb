#Given an array, and a window size w, find the maximum range (max - min) within a set of w elements.

#Phase 1 - Naive Solution

# def windowed_max_range(array, window_length)
#     current_max_range = 0
#     (0..(array.length-window_length)).each do |idx|
#         window = array[idx...(idx+window_length)]
#         range = window.max - window.min
#         if range > current_max_range 
#             current_max_range = range
#         end
#     end
#     current_max_range
# end

# p windowed_max_range([1, 0, 2, 5, 4, 8], 2) == 4 # 4, 8
# p windowed_max_range([1, 0, 2, 5, 4, 8], 3) == 5 # 0, 2, 5
# p windowed_max_range([1, 0, 2, 5, 4, 8], 4) == 6 # 2, 5, 4, 8
# p windowed_max_range([1, 3, 2, 5, 4, 8], 5) == 6 # 3, 2, 5, 4, 8


# Phase 2
# Implement peek, size, empty?, enqueue, and dequeue methods on your Queue.

class MyQueue
    def initialize
        @store = []
    end

    def enqueue(ele)
        @store.unshift(ele)
    end

    def dequeue
        @store.pop
    end

    def size
        @store.length
    end

    def empty?
        @store.empty?
    end

    def peek
        @store.last
    end
end

#Phase 3: MyStack

class MyStack
    def initialize
        @store = []
    end

    def push(element)
        @store.push(element)
    end

    def pop
        @store.pop
    end

    def size
        @store.length
    end

    def empty?
        @store.empty?
    end

    def peek
        @store.last
    end

end

class StackQueue
    def initialize
        @q1 = MyStack.new
        @q2 = MyStack.new
    end

    def enqueue(element)
        @q1.push(element)
    end
    
    def dequeue
        if @q2.empty?
            until @q1.empty?
                @q2.push(@q1.pop)
            end
        end
        @q2.pop
    end

    def size
        @q1.size + @q2.size
    end

    def empty?
        @q1.empty? && @q2.empty?
    end

end

class MinMaxStack
    def initialize
        @store = MyStack.new
    end

    def peek
        @store.peek[:value] unless empty?
    end

    def max
        @store.peek[:max] unless empty?
    end

    def min
        @store.peek[:min] unless empty?
    end

    def size
        @store.size
    end

    def empty?
        @store.empty?
    end

    def set_max(ele)
        if empty?
            ele
        else
            [max,ele].max
        end
    end

    def set_min(ele)
        if empty?
            ele
        else
            [min,ele].min
        end
    end

    def push(ele)
        @store.push(
            {max: set_max(ele), min: set_min(ele), value: ele}
        )

    end

    def pop
        @store.pop[:value] unless empty?
    end
end

class MinMaxStackQueue
    def initialize
        @input = MinMaxStack.new
        @output = MinMaxStack.new
    end
    
    def enqueue(element)
        @input.push(element)
    end
    
    def dequeue
        if @output.empty?
            until @input.empty?
                @output.push(@input.pop)
            end
        end
        @output.pop
    end

    def size
        @input.size + @output.size
    end

    def empty?
        @input.empty? && @output.empty?
    end

    def max
        maxes = []
        unless @input.empty?
            maxes << @input.max
        end

        unless @output.empty?
            maxes << @output.max
        end

        maxes.max
    end

    def min
        mins = []
        mins << @input.min unless @input.empty?
        mins << @output.min unless @output.empty?
        mins.min
    end


end

def windowed_max_range(array, window_length)
    current_max_range = nil
    queue = MinMaxStackQueue.new

    array.each_with_index do |ele, idx|
        queue.enqueue(ele)
        queue.dequeue if queue.size > window_length

        if queue.size == window_length
            range = queue.max - queue.min
            if !current_max_range || range > current_max_range
                current_max_range = range
            end
        end
    end

    current_max_range
end

p windowed_max_range([1, 0, 2, 5, 4, 8], 2) == 4 # 4, 8
p windowed_max_range([1, 0, 2, 5, 4, 8], 3) == 5 # 0, 2, 5
p windowed_max_range([1, 0, 2, 5, 4, 8], 4) == 6 # 2, 5, 4, 8
p windowed_max_range([1, 3, 2, 5, 4, 8], 5) == 6 # 3, 2, 5, 4, 8