require_relative './piece.rb'

class Board

    attr_accessor :rows

    def initialize
        create_board
    end

    def create_board
        valid_rows = [0,1,6,7]
        @rows = Array.new(8){Array.new(8)}
        @rows.each_with_index do |row, row_idx|
            #Non-Null Rows
            if valid_rows.include?(row_idx)
                #Back row - black
                if row_idx == 0 
                    row.each_with_index do |square, square_idx|
                        if square_idx == 0 || square_idx == 7
                            row[square_idx] = Rook.new(:black, self, [row_idx,square_idx])
                        elsif square_idx == 1 || square_idx == 6
                            row[square_idx] = Knight.new(:black, self, [row_idx,square_idx])
                        elsif square_idx == 2 || square_idx == 5
                            row[square_idx] = Bishop.new(:black, self, [row_idx,square_idx])   
                        elsif square_idx == 3
                            row[square_idx] = Queen.new(:black, self, [row_idx,square_idx])
                        elsif square_idx == 4
                            row[square_idx] = King.new(:black, self, [row_idx,square_idx])
                        end
                    end
                elsif row_idx == 1
                    row.each_with_index {|square, square_idx| row[square_idx] = Pawn.new(:black, self, [row_idx,square_idx])}
                #White
                elsif row_idx == 6
                    row.each_with_index {|square, square_idx| row[square_idx] = Pawn.new(:white, self, [row_idx,square_idx])}
                elsif row_idx == 7
                   row.each_with_index do |square, square_idx|
                        if square_idx == 0 || square_idx == 7
                            row[square_idx] = Rook.new(:white, self, [row_idx,square_idx])
                        elsif square_idx == 1 || square_idx == 6
                            row[square_idx] = Knight.new(:white, self, [row_idx,square_idx])
                        elsif square_idx == 2 || square_idx == 5
                            row[square_idx] = Bishop.new(:white, self, [row_idx,square_idx])   
                        elsif square_idx == 3
                            row[square_idx] = Queen.new(:white, self, [row_idx,square_idx])
                        elsif square_idx == 4
                            row[square_idx] = King.new(:white, self, [row_idx,square_idx])
                        end
                    end                    
                end
            else
                row.each_with_index {|square, square_idx| row[square_idx] = NullPiece.instance}

            end
        end
    end

    def back_row(colour)

    end

    def pawns_row(colour)

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
        self[pos] = piece
    end

    def checkmate?(colour)
        return false unless in_check?(colour)

        colour_pieces = pieces.select {|piece| piece.colour = colour}
        
        colour_pieces.all? do |piece|
            piece.valid_moves.empty?
        end

    end

    def in_check?(colour)
        pieces.any? do |piece|
            piece.colour != colour && piece.moves.include?(find_king(:colour))
        end
    end

    def find_king(colour)
        rows.each_with_index do |row,i|
            row.each_with_index do |tile,j|
                if tile.symbol == "K" && tile.colour == colour
                    return [i,j]
                end
            end
        end
    end

    def pieces
        @rows.flatten.reject(&:empty?)
    end

    def dup

    end

    def move_piece!(color, start_pos, end_pos)

    end


    private
    attr_reader :sentinel
end

# a = Board.new
# p a.in_check?(:white)
# p a.checkmate?(:white)
