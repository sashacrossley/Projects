#Given an array, and a window size w, find the maximum range (max - min) within a set of w elements.

#Phase 1 - Naive Solution

def windowed_max_range(array, window_length)
    current_max_range = 0
    (0..(array.length-window_length)).each do |idx|
        window = array[idx...(idx+window_length)]
        range = window.max - window.min
        if range > current_max_range 
            current_max_range = range
        end
    end
    current_max_range
end

# p windowed_max_range([1, 0, 2, 5, 4, 8], 2) == 4 # 4, 8
# p windowed_max_range([1, 0, 2, 5, 4, 8], 3) == 5 # 0, 2, 5
# p windowed_max_range([1, 0, 2, 5, 4, 8], 4) == 6 # 2, 5, 4, 8
# p windowed_max_range([1, 3, 2, 5, 4, 8], 5) == 6 # 3, 2, 5, 4, 8