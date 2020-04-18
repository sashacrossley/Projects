class Tile

    attr_reader :bomb

    def initialize(board, pos)
        @board = board
        @pos = pos
        @bomb = false
        @explored = false
        @flagged = false
    end

    def reveal

    end

    def neighbours

    end

    def neighbour_bomb_count

    end

    def plant_bomb
        @bomb = true
    end

    def inspect
        {'pos' => @pos, 'bomb' => @bomb}.inspect
    end



end