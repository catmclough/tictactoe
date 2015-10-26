module TicTacToe
  class GameCreator
    attr_reader :game

    def initialize(view)
      @view = view
    end

    def opening_message
      clear_screen
      @view.puts "Welcome to my Tic Tac Toe game!"
      game_type_options
    end

    def clear_screen
      print "\e[2J"
    end

    def game_type_options
      @view.puts "Please choose a game type:"
      @view.puts "1. You vs. Computer"
      @view.puts "2. 2-Player"
      @view.puts "3. Computer vs. Computer"
    end

    def choose_type
      @game = nil
      until @game
        type = gets.chomp
        create_new_game(type)
      end
    end

    def create_new_game(type)
      case type
      when '1'
        @game = ClassicGame.new
      when '2'
        @game = TwoPlayerGame.new
      when '3'
        @game = TwoComputerGame.new
      else
        @view.puts "Invalid game type. Please choose 1, 2, or 3:"
      end
    end

    def set_markers
      prompt_player_marker(1)
      choose_player_marker(1)
      prompt_player_marker(2)
      choose_player_marker(2)
    end

    def prompt_player_marker(player)
      if player == 1 && @game.player_one.is_a?(TicTacToe::Player)
        @view.print "Player 1 - Choose your marker: "
      elsif @game.player_two.is_a?(TicTacToe::Player)
        @view.print "Player 2 - Choose your marker: "
      end
    end

    def choose_player_marker(player)
      if (player == 1 && @game.player_one.is_a?(TicTacToe::Player)) || (player == 2 && @game.player_two.is_a?(TicTacToe::Player))
          marker_choice = gets.chomp
          until @game.set_player_marker(player, marker_choice)
            invalid_marker_choice
            prompt_player_marker(player)
            marker_choice = gets.chomp
          end
        end
    end

    def invalid_marker_choice
      @view.puts "Invalid entry. Marker must be one character and cannot be a number or the same as your opponent's (FYI: The computer will always be 'X')."
    end

    def set_player_turns
      prompt_turn_selection
      choose_turns
    end

    def prompt_turn_selection
      if @game.player_one.is_a?(Player)
        if @game.player_two.is_a?(Player)
          @view.print "Enter the marker of the player who will go first: "
        else
          @view.print "Would you like to go first or second? (Enter 1 or 2): "
        end
      end
    end

    def choose_turns
      unless @game.is_a?(TicTacToe::TwoComputerGame)
        choice = gets.chomp
        until @game.valid_turn_choice?(choice)
          invalid_turn_choice_message
          prompt_turn_selection
          choice = gets.chomp
        end
        set_turn(choice)
      end
    end

    def set_turn(choice)
      @game.set_turns(choice)
    end

    def invalid_turn_choice_message
      @view.puts"Invalid Turn Choice."
    end

    def play_game
      if @player_one.turn == '1'
        first_turn = @player_one
        second_turn = @player_two
      else
        first_turn = @player_two
        second_turn = @player_one
      end

      until @board.winner(@board.state) || @board.tie?(@board.state)
        play_round(first_turn, second_turn)
      end
      end_game
    end

    def play_round(first_player, second_player)
      @view.clear_screen
      @view.display_header(first_player.marker, second_player.marker)
      @view.draw_board(@board.state)
      @view.active_player_message(first_player)

      if first_player.is_a?(Player)
        if second_player.is_a?(Computer)
          @view.computer_choice_message(second_player.best_move) if second_player.best_move
        end

        player_move(first_player)
        @view.clear_screen
        @view.display_header(first_player.marker, second_player.marker)
        @view.draw_board(@board.state)
      else
        choice = computer_move(first_player)
        @view.clear_screen
        @view.display_header(first_player.marker, second_player.marker)
        @view.draw_board(@board.state)
        @view.computer_choice_message(choice)
      end

      unless over?
        @view.active_player_message(second_player)
        computer_move(second_player) if second_player.is_a?(Computer)
        player_move(second_player) if second_player.is_a?(Player)
      end
    end

    def player_move(player)
      @view.display_move_instructions
      choice = player.choose_spot(@board.state)
      until choice
        @view.incorrect_placement_error
        choice = player.choose_spot(@board.state)
      end
      @board.place_marker(choice, player.marker)
    end

    def computer_move(player)
      @view.thinking_message
      choice = player.choose_move(@board, @board.state)
      @board.place_marker(choice, player.marker)
      choice
    end

    def over?
      @board.winner(@board.state) || @board.tie?(@board.state)
    end

    def end_game
      if @board.tie?(@board.state)
        @view.end_of_tie_game(@board.state)
      else
        @view.winner_message(@board.winner(@board.state), @board.state)
      end
    end
  end
end