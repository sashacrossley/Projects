require_relative "./Tile.rb"

class Board
    attr_reader :grid

    def initialize
           @grid = Array.new(9) do |row|
            Array.new(9) { |col| Tile.new(self, [row, col]) }
           end
    end

    # def [](pos)
    #     row, col = pos
    #     grid[row][col]
    # end
    
    def mine #randomly spread mines
        count = 0
        until count == 10
            row = rand(0..8)
            col = rand(0..8)
            if !@grid[row][col].bomb
                @grid[row][col].plant_bomb
                count +=1
            end
        end
    end

    def p_bomb(row,col)
        @grid[row][col].plant_bomb
    end

end

a = Board.new
a.mine
p a