require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos
  
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

#characterize a node as either a winner or a loser for a particular mark (evaluator).

  def losing_node?(evaluator)
    if board.over?
      return board.won? && board.winner != evaluator
    end

    if self.next_mover_mark == evaluator
      #It is the player's turn, and all the children nodes are losers for the player (anywhere they move they still lose)
      self.children.all? {|node| node.losing_node?(evaluator)}
    else
      #It is the opponent's turn, and one of the children nodes is a losing node for the player (assumes your opponent plays perfectly; they'll force you to lose if they can).
      self.children.any? {|node| node.losing_node?(evaluator)}
    end
  end

  def winning_node?(evaluator)
    if board.over?
      return board.winner == evaluator
    end

    if self.next_mover_mark == evaluator
      self.children.any? {|node| node.winning_node?(evaluator)}
    else
      self.children.all? {|node| node.winning_node?(evaluator)}
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    children = []
    (0..2).each do |row_idx|
          (0..2).each do |col_idx|
            pos = [row_idx, col_idx]

            #For each empty position, create a node by duping the board and putting a next_mover_mark in the position.
            next unless board.empty?(pos)

            new_board = board.dup
            new_board[pos] = self.next_mover_mark
            #You'll want to alternate next_mover_mark so that next time the other player gets to move.
            next_mover_mark = (self.next_mover_mark == :x ? :o : :x)

            children << TicTacToeNode.new(new_board, next_mover_mark, pos) #Also, set prev_move_pos to the position you just marked,
          end
    end
    children
  end
end
