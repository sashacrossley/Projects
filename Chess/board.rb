require_relative './piece.rb'

class Board

    attr_accessor :rows

    def initialize
        
    end

    def create_board
        valid_rows = [0,1,6,7]
        @rows = Array.new(8){Array.new(8)}
        @rows.each_with_index do |row, row_idx|
            if valid_rows.include?(row_idx)
                row.each_with_index do |square, square_idx|
                    row[square_idx] = Piece.new
                end
            end
        end
    end
    
    def [](pos)
        row, col = pos
        @rows[row][col]
    end

    def []=(pos,val)
        row, col = pos
        @rows[row][col] = val
    end

    def move_piece(start_pos, end_pos)
        raise "no piece" if self[start_pos].nil?
        raise "invalid pos" if !valid_pos?(end_pos)

        piece = self[start_pos]
        self[end_pos] = piece
        self[start_pos] = nil

    end

    def valid_pos?(pos)
        pos.all? { |coord| coord.between?(0, 7) }
    end

    def add_piece(piece, pos)

    end

    def checkmate?(color)

    end

    def in_check?(color)

    end

    def find_king(color)

    end

    def pieces

    end

    def dup

    end

    def move_piece!(color, start_pos, end_pos)

    end


    private
    attr_reader :sentinel
end