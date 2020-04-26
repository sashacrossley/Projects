require_relative './polytreenode.rb'

class KnightPathFinder

    DELTAS = [
        [-2, -1],
        [-2, 1],
        [-1, -2],
        [-1, 2],
        [2, -1],
        [2, 1],
        [1, -2],
        [1, 2]
    ].freeze

    attr_reader :starting_pos

    def initialize(starting_pos)
        @starting_pos = starting_pos
        build_move_tree
        @considered_positions = [starting_pos] #keep track of the positions you have considered
    end

    def self.valid_moves(pos) #find new positions you can move to from a given position.
        all_coord = 
        DELTAS.map do |(dx,dy)|
            [pos[0] + dx, pos[1] +dy]
        end

        valid_coord = 
        all_coord.select do |row, col|
            [row,col].all? do |coord|
                coord.between?(0,8)
            end
        end

        valid_coord
    end
    
    def self.root_node
        @root_node = PolyTreeNode.new(starting_pos)
    end

    def build_move_tree 

    end

    def find_path

    end

    def new_move_positions(pos) #call the ::valid_moves class method, but filter out any positions that are already in @considered_positions. It should then add the remaining new positions to @considered_positions and return these new positions.

    end

end