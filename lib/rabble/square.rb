module Rabble
  class Square
    attr_reader :board, :row, :col, :letter_multiplier, :word_multiplier
    attr_accessor :letter

    def initialize(board, row, col, opts = {})
      @board = board
      @row = row
      @col = col
      @letter_multiplier = opts[:letter_multipler] || 1
      @word_multiplier = opts[:word_multiplier] || 1
    end

    def empty?
      letter.nil?
    end

    def full?
      !empty?
    end

    def clear
      self.letter = nil
    end

    def square_left(count = 1)
      col >= count ? board.square_at(row, col - count) : nil
    end

    def square_right(count = 1)
      board.square_at(row, col + count)
    end

    def square_up(count = 1)
      row >= count ? board.square_at(row - count, col) : nil
    end

    def square_down(count = 1)
      board.square_at(row + count, col)
    end

    def full_square_up_or_down?
      (square_up && square_up.full?) || (square_down && square_down.full?)
    end

    def full_square_left_or_right?
      (square_left && square_left.full?) || (square_right && square_right.full?)
    end

    def sequence_left
      if square_left && square_left.full?
        square_left.sequence_left.push(square_left.letter)
      else
        []
      end
    end

    def sequence_right
      if square_right && square_right.full?
        square_right.sequence_right.unshift(square_right.letter)
      else
        []
      end
    end

    def sequence_up
      if square_up && square_up.full?
        square_up.sequence_up.push(square_up.letter)
      else
        []
      end
    end

    def sequence_down
      if square_down && square_down.full?
         square_down.sequence_down.unshift(square_down.letter)
      else
        []
      end
    end
  end
end