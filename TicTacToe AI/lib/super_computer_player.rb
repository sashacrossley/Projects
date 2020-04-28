require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    node = TicTacToeNode.new(game.board, mark)
    winning_node = nil
    
    #If any of the children is a winning_node? for the mark passed in to the #move method, return that node's prev_move_pos
    node.children.each do |child|
      if child.winning_node?(mark)
        winning_node = child
        break
      end
    end

    return winning_node.prev_move_pos if winning_node

    #If none of the children of the node we created are winning_node?s, that's ok. We can just pick one that isn't a losing_node? and return its prev_move_pos
    node.children.each do |child|
      if !child.losing_node?(mark)
        winning_node = child
        break
      end
    end

    return winning_node.prev_move_pos if winning_node
    raise "Tis isn't fair"
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
