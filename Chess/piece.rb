require 'singleton'
#require_relative './board.rb'
##remmber to replace nil refernces with colour once you've implemented whole board
module Stepable

    def moves
        moves = []
        move_diffs.each do |dx, dy|
            x, y = pos
            pos = [x + dx, y + dy]
            if board.valid_pos?(pos) && board[pos].colour != colour #board[pos].nil?
                moves << pos
            elsif board.valid_pos?(pos) && board[pos].empty?
                moves << pos
            end
        end
        moves
    end

    private
    def move_diffs
        # subclass implements this
        raise NotImplementedError
    end

end

module Slideable

    DIAGONAL_DIRS = [
        [1,1],
        [1,-1],
        [-1,1],
        [-1,-1]
    ].freeze

    HORIZONTAL_DIRS = [
        [0,1],
        [0,-1],
        [1,0],
        [-1,0]
    ].freeze

    def horizontal_dirs
        HORIZONTAL_DIRS
    end

    def diagonal_dirs
        DIAGONAL_DIRS
    end

    def moves
        #use move_dirs from individual piece class
        moves = []
        move_dirs.each do |dx, dy|
            moves.concat(grow_unblocked_moves_in_dir(dx, dy))
        end
        moves
    end

    private 

    def move_dirs
        # subclass implements this
        raise NotImplementedError
    end

    def grow_unblocked_moves_in_dir(dx, dy)
        moves = []
        x, y = pos
        x = x + dx
        y = y + dy
        pos = [x, y]
        while board.valid_pos?(pos) && board[pos].colour != colour #board[pos].nil? 
            moves << pos
            x = x + dx
            y = y + dy
            pos = [x, y]
        end
    moves
    end
end

class Piece
attr_reader :board, :colour
attr_accessor :pos

    def initialize(colour, board, pos)
        @colour = colour
        @board = board
        @pos = pos

        board.add_piece(self, pos)
    end

    def to_s
        " #{symbol} "
    end

    def empty?
        false
    end

    def valid_moves
        moves.reject {|end_pos| move_into_check?(end_pos)}
    end

    # def pos=(val)

    # end

    def symbol
        # subclass implements this with unicode chess char
        raise NotImplementedError
    end

    private

    def move_into_check?(end_pos)
        new_board = board.dup
        new_board.move_piece!(pos, end_pos)
        new_board.in_check?(colour)
    end

end

class Rook < Piece
include Slideable
    def symbol
        "R"
    end

    protected
    def move_dirs
        horizontal_dirs
    end
    
end

class Bishop < Piece
include Slideable
    def symbol
        "B"
    end

    protected
    def move_dirs
        diagonal_dirs
    end
    
end

class Queen < Piece
include Slideable
    def symbol
        "Q"
    end

    protected
    def move_dirs
        diagonal_dirs + horizontal_dirs
    end
    
end

class King < Piece
include Stepable
    def symbol
        "K"
    end

    # protected
    def move_diffs
    [[1,1],
     [1,-1],
     [-1,1],
     [-1,-1],
     [0,1],
     [0,-1],
     [1,0],
     [-1,0]]
    end
    
end

class Knight < Piece
include Stepable
    def symbol
        "N"
    end

    protected
    def move_diffs
    [
        [-2, -1],
        [-2, 1],
        [-1, -2],
        [-1, 2],
        [2, -1],
        [2, 1],
        [1, -2],
        [1, 2]
    ]
    end
    
end


class NullPiece < Piece
    attr_reader :symbol
    
    include Singleton
    def initialize
        @symbol = " "
        @color = :none
    end

    def moves
        []
    end

    def empty?
        true
    end
end

class Pawn < Piece

    def symbol
        "P"
    end

    def moves
        forward_steps + side_attacks
    end

    def at_start_row?
        board[pos].pos[0] == 
        if colour == :black
            1 
        else
            6
        end
    end

    private

    def forward_dir
        if colour == :black
            1
        else
            -1
        end
    end

    def forward_steps
        x, y = pos
        moves = []
        pos = [x + forward_dir, y]
        if board.valid_pos?(pos) && board[pos].empty? 
            moves << pos
        end

        pos = [(x + (2*forward_dir)), y]
        if at_start_row? && board[pos].empty? 
            moves << pos
        end
        moves
    end

    def side_attacks 
        x, y = pos
        possible_moves = [[x + forward_dir, y + 1], [x + forward_dir, y - 1]]
        moves = []
        possible_moves.each do |move|
            if board.valid_pos?(move) && !board[move].empty? && board[move].colour != colour #!board[move].nil? 
                 moves << move
            else 
                next
            end
        end
        moves
    end

end

