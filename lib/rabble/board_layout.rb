module Rabble
  class BoardLayout
    def initialize(board_data = nil)
      @board_data = board_data || Rabble::Systems::Standard::BOARD_DATA
    end

    def size
      @board_data[:size]
    end

    def letter_multiplier(row, col)
      @board_data[:letter_multiplier][row][col]
    end

    def word_multiplier(row, col)
      @board_data[:word_multiplier][row][col]
    end
  end
end