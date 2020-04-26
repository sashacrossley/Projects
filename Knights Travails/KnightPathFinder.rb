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

    attr_reader :starting_pos, :considered_positions
    attr_accessor :root_node

    def initialize(starting_pos)
        @starting_pos = starting_pos
        @considered_positions = [starting_pos] #keep track of the positions you have considered
        build_move_tree
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

    def build_move_tree 
        self.root_node = PolyTreeNode.new(starting_pos)
        queue = [root_node]
        until queue.empty?
            current_node = queue.shift
            position = current_node.value
            new_move_positions(position).each do |child|
                child_node = PolyTreeNode.new(child)
                current_node.add_child(child_node)
                queue << child_node
            end
        end
    end

    def find_path(end_pos)
        end_node = root_node.dfs(end_pos)
        trace_path_back(end_node).reverse
    end

    def trace_path_back(end_node)
        path_array = []
        current_node = end_node
        until current_node.nil?
            path_array << current_node.value
            current_node = current_node.parent
        end
        path_array
    end

    def new_move_positions(pos) #call the ::valid_moves class method, but filter out any positions that are already in @considered_positions. It should then add the remaining new positions to @considered_positions and return these new positions.
        new_moves = []
        KnightPathFinder.valid_moves(pos).each do |pos|
            unless considered_positions.include?(pos)
                new_moves << pos
                considered_positions << pos
            end
        end
        new_moves
    end

end

a = KnightPathFinder.new([0,0])
p a.find_path([7,6])
p a.find_path([6,2])