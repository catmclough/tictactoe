class Computer
  attr_reader :best_move, :marker
  attr_accessor :turn

  def initialize(marker = 'X')
    @marker = marker
  end

  def choose_move(board, state)
    @best_move = nil
    minimax(board, state)
    @best_move
  end

  def minimax(board, board_state)
    if board.winner(board_state) || board.tie?(board_state)
      return score_spot(board, board_state)
    end

    scores = []
    moves = []
    available_spaces = board.get_open_spaces(board_state)

    available_spaces.each do |space|
      possible_board_state = board_state.dup
      possible_board_state[space] = board.active_player(possible_board_state, turn)
      scores << minimax(board, possible_board_state).to_i
      moves << space
    end

    if board.active_player(board_state, turn) == @marker
      max_score = scores[0]
      max_score_index = 0

      scores.each_with_index do |score, index|
        if score > max_score
          max_score = score
          max_score_index = index
        end
      end

      @best_move = moves[max_score_index]
      return scores[max_score_index]
    else
      min_score = scores[0]
      min_score_index = 0

      scores.each_with_index do |score, index|
        if score < min_score
          min_score = score
          min_score_index = index
        end
      end

      @best_move = moves[min_score_index]
      return scores[min_score_index]
    end
  end

  def score_spot(board, board_state)
    if board.winner(board_state) == @marker
      return 1
    elsif board.winner(board_state)
      return -1
    else
      return 0
    end
  end
end
