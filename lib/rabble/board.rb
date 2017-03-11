module Rabble
  class Board
    attr_reader :rows, :tile_system

    def initialize(board_layout, tile_system)
      @rows = (0..board_layout.size-1).map do |row|
        (0..board_layout.size-1).map do |col|
          Square.new(self, row, col,
            letter_multiplier: board_layout.letter_multiplier(row, col),
            word_multiplier: board_layout.word_multiplier(row, col))
        end
      end
      @tile_system = tile_system
    end

    def size
      rows.size
    end

    def each_square
      return enum_for(:each_square) unless block_given?

      rows.each do |row|
        row.each do |square|
          yield square
        end
      end
    end

    def square_at(row, col)
      rows[row] && rows[row][col]
    end

    def center_square
      square_at(size / 2, size / 2)
    end

    def clear
      each_square(&:clear)
    end

    def tiles_played
      each_square.reduce(0) { |count, square| square.full? ? count + 1 : count }
    end

    def empty?
      tiles_played == 0
    end

    def place_word(word, square, direction, dictionary)
      score = self.score(word, square, direction, dictionary)

      placed_letters = []
      word.each_char do |letter|
        if square.empty?
          square.letter = letter
          placed_letters << letter
        end
        square = direction == :horizontal ? square.square_right : square.square_down
      end

      [score, placed_letters]
    end

    def score(word, square, direction, dictionary, include_adjoining = true)
      word_multiplier = 1
      word_score = adjoining_score = 0
      word.each_char do |letter|
        raise IllegalPlacementError, "Not a valid square" if !square
        points = tile_system.points(letter)
        if square.empty?
          points *= square.letter_multiplier
          word_multiplier *= square.word_multiplier

          if include_adjoining
            prefix = direction == :horizontal ? square.sequence_up : square.sequence_left
            suffix = direction == :horizontal ? square.sequence_down : square.sequence_right
            if prefix.length > 0 || suffix.length > 0
              adjoining_word = prefix.join + letter + suffix.join
              raise IllegalPlacementError, "Invalid adjoining word '#{adjoining_word}'" unless dictionary.include_word?(adjoining_word)
              adjoining_word_square = direction == :horizontal ? square.square_up(prefix.length) : square.square_left(prefix.length)
              adjoining_score += score(adjoining_word, adjoining_word_square, direction == :horizontal ? :vertical : :horizontal, dictionary, false)
            end
          end
        elsif square.letter != letter
          raise IllegalPlacementError, "Square (#{row}, #{col}) already occupied"
        end
        word_score += points
        square = direction == :horizontal ? square.square_right : square.square_down
      end
      word_score * word_multiplier + adjoining_score
    end

    def print
      rows.each do |row|
        puts row.map { |square| "#{square.letter || '.'} "}.join
      end
      puts
    end
  end
end