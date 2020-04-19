class Tile
  DELTAS = [
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 0, -1],
    [ 0,  1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1]
  ].freeze
    attr_reader :bomb, :flagged, :explored, :value

    def initialize(board, pos)
        @board = board
        @pos = pos
        @bomb = false
        @explored = false
        @flagged = false
    end

    def render
        if flagged
            "F"
        elsif explored
            if neighbour_bomb_count == 0
                "_"
            else
                neighbour_bomb_count.to_s
            end
        elsif bomb
            "B"
        else
            "*"
        end
    end
    
    def reveal # used to fully reveal the board at game end

    end

    def neighbours
        adjacent_coords = DELTAS.map do |(dx, dy)|
            [pos[0] + dx, pos[1] + dy]
        end.select do |row, col|
            [row, col].all? do |coord|
                coord.between?(0, @board.grid_size - 1)
            end
        end
    end

    def neighbour_bomb_count
        neighbours.select(&:bomb).count
    end

    def plant_bomb
        @bomb = true
    end

    def explore
        @explored = true
    end

    # def inspect
    #     @value.inspect
    # end

    # def inspect
    # # don't show me the whole board when inspecting a Tile; that's
    # # information overload.
    # { pos: pos,
    #   bomb: bomb,
    #   flagged: flagged,
    #    explored: explored }.inspect
    # end



end

