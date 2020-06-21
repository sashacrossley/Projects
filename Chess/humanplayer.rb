require_relative './player.rb'
require_relative './display.rb'

class HumanPlayer < Player

    def make_move(_board)
        start_pos = nil
        end_pos = nil

        until start_pos && end_pos
            puts display.render
            if start_pos
                puts "#{colour}'s turn. Your move?"
                end_pos = display.cursor.get_input
                # display.reset! if end_pos
            else
                puts "#{colour}'s turn. Your move?"
                start_pos = display.cursor.get_input

            end
        end
        [start_pos, end_pos]
    end

end