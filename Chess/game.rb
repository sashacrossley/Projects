require_relative './board.rb'
require_relative './humanplayer.rb'

class Game
    attr_reader :board, :display, :current_player, :players

    def initialize
        @board = Board.new
        @display = Display.new(@board)
        @players = {
            white: HumanPlayer.new(:white, @display),
            black: HumanPlayer.new(:black, @display)
        }
        @current_player = :white
    end

    def play
        until board.checkmate?(current_player)
            begin
                start_pos, end_pos = players[current_player].make_move(board)
                board.move_piece(current_player, start_pos, end_pos) 
                swap_turn!
            rescue StandardError => e
                puts e.message
                sleep(2)
                retry
            end
        end

        display.render
        puts "#{current_player} is checkmated."
    end

    private
    def notify_players

    end

    def swap_turn!
        if @current_player == :white
            @current_player = :black
        else
            @current_player = :white
        end
    end


end

if $PROGRAM_NAME == __FILE__
    Game.new.play
end