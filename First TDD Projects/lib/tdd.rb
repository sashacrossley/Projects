def my_uniq(array)
    new_arr = []
    array.each do |ele|
        unless new_arr.include?(ele)
            new_arr << ele
        end
    end
    new_arr
end

def two_sum(array)
    new_arr = []
    array.each_with_index do |ele, idx1|
        array.each_with_index do |ele, idx2|
            if array[idx1] + array [idx2] == 0 && idx1 <  idx2
                new_arr << [idx1, idx2]
            end
        end
    end
    new_arr
end

def my_transpose(matrix)
    new_matrix = Array.new(matrix.length) {Array.new(matrix.length)}
    
    (0...matrix.length).each do |row_idx|
        (0...matrix.length).each do |col_idx|
            value = matrix[row_idx][col_idx]
            new_matrix[col_idx][row_idx] = value
        end
    end
    new_matrix
end

def pick_stocks(prices)
    pairs = []
    prices.each_with_index do |price1, day1|
        prices.each_with_index do |price2, day2|
            pairs << [day1, day2] if day2 > day1 && price2 > price1
        end
    end
    return nil if pairs.empty?
    pairs_hash = {}
    pairs.each do |pair|
        pairs_hash[pair] = (prices[pair[1]]-prices[pair[0]])
    end
    pairs_hash.sort_by {|k,v| v}.last[0]
end

class TowersOfHanoi

    attr_reader :stacks
    def initialize
        @stacks = [[1,2,3],[],[]]
    end

    def move(start_tower, end_tower)
        raise "can't move from empty stack" if @stacks[start_tower].empty?
        raise "can't move a large onto a small" unless (@stacks[end_tower].empty?|| @stacks[end_tower][0] > @stacks[start_tower][0] )
        @stacks[end_tower].unshift(@stacks[start_tower].shift)
    end

    def won?
        (@stacks[0].empty? && @stacks[1] == [1,2,3]) || (@stacks[0].empty? && @stacks[2] == [1,2,3]) 
    end

    def play
        display

        until won?
            puts "What tower do you want to move from?"
            from_tower = gets.to_i

            puts "What tower do you want to move to?"
            to_tower = gets.to_i

            begin
                move(from_tower, to_tower)
                display
            rescue
                display
                puts "Invalid move. Try again." 
            end
        end
        puts "you win!"
    end

    def render
        'Tower 0:  ' + @stacks[0].join('  ') + "\n" +
      'Tower 1:  ' + @stacks[1].join('  ') + "\n" +
      'Tower 2:  ' + @stacks[2].join('  ') + "\n"
    end
    
    def display
        system('clear')
        puts render
    end


end

test_game = TowersOfHanoi.new
test_game.play
