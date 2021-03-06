module TicTacToe
  class Player
    attr_accessor :marker, :turn

    def choose_turn
      turn_choice = gets.chomp
      if turn_choice == '2'
        self.turn = turn_choice
      else
        self.turn = '1'
      end
    end

    def choose_spot(board)
      spot = gets.chomp
      return nil if Player.invalid_move?(spot, board)
      spot
    end

    def validate_marker(player_marker, opponent_marker)
      Player.invalid_marker?(player_marker, opponent_marker) ? false : true
    end

    def self.invalid_marker?(entry, opponent_marker = nil)
      entry.length == 0 || /\A\d+\z/.match(entry) != nil || entry.length > 1 || entry == opponent_marker
    end

    def self.invalid_move?(spot, board_state)
      !("0".."8").include?(spot) || !("0".."8").include?(board_state[spot.to_i].to_s)
    end
  end
end