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

    def print_board
        @grid.map do |row|
            row.map do |tile|
                tile.render
            end.join("")
        end.join("\n")
    end

    def explore(row,col)
        @grid[row][col].explore
    end


end

a = Board.new
a.mine
puts a.print_board

# Todo
# render indiviaul tiles depending on status - done
# print board based on the rendered tiles - done
# calculate whether tiles have a bomb

# Input
# Explore tile
# Flag bomb
