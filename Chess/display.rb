require 'colorize'
require_relative './cursor.rb'
require_relative './board.rb'

class Display
    attr_reader :cursor
    def initialize(board)
        @board = board
        @cursor = Cursor.new([0,0], board)
    end

    def render
        @board.rows.map.with_index do |row, i|
            row.map.with_index do |tile, j|
                if cursor.cursor_pos == [i,j] && cursor.selected
                    tile.symbol.colorize(tile.colour).colorize(:background =>:green)
                elsif cursor.cursor_pos == [i,j]
                    tile.symbol.colorize(tile.colour).colorize(:background =>:red)
                elsif (i+j).odd?
                    tile.symbol.colorize(tile.colour).colorize(:background =>:light_blue)
                else
                    tile.symbol.colorize(tile.colour).colorize(:background =>:light_black)
                end
            end.join("")
        end.join("\n")
    end
    
    def test
        loop do
            system("clear")
            puts render
            cursor.get_input
        end
    end

end

# a = Display.new(Board.new)
# a.test