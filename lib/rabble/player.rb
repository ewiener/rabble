require 'pry'

module Rabble
  class Player
    attr_reader :game, :rack
    attr_accessor :score, :name

    def initialize(game, name)
      @game = game
      @name = name
      @rack = Rack.new
      reset
    end

    def reset
      rack.clear
      rack.refill_from(game.bag)
      self.score = 0
    end

    def play
      play = best_play
      if play[:word]
        score, placed_letters = game.board.place_word(play[:word], play[:square], play[:direction], game.dictionary)
        rack.remove_tiles(placed_letters)
        rack.refill_from(game.bag)
        self.score += score
        game.log.log(self, play[:word], play[:square], play[:direction], score, placed_letters)
      else
        game.log.log(self, nil)
      end
    end

    def played_out?
      rack.empty?
    end

    #private

    def best_play
      if game.board.empty?
        best_first_play
      else
        best_connected_play
      end
    end

    def best_first_play
      center = game.board.center_square

      possible_words = rack.words(game.dictionary, 1..7)
      possible_words.reduce({ score: 0 }) do |best, word|
        (center.col - word.length + 1 .. center.col).reduce(best) do |best, col|
          square = game.board.square_at(center.row, col)
          begin
            score = game.board.score(word, square, :horizontal, game.dictionary)
            if score > best[:score]
              { score: score, word: word, square: square, direction: :horizontal }
            else
              best
            end
          rescue IllegalPlacementError
            # Should never happen
            best
          end
        end
      end
    end

    def best_connected_play
      game.board.each_square.reduce({ score: 0 }) do |best, square|
        next best if square.full?
        possible_plays_at(square).reduce(best) do |best, play|
          begin
            score = game.board.score(play[:word], play[:square], play[:direction], game.dictionary)
            if score > best[:score]
              { score: score, word: play[:word], square: play[:square], direction: play[:direction] }
            else
              best
            end
          rescue IllegalPlacementError
            # Happens if there were any invalid adjoining words
            best
          end
        end
      end
    end

    def possible_plays_at(square)
      %i(horizontal vertical).flat_map do |direction|
        template, starting_square, first_intersection = template_at(square, direction)
        if template.any? || first_intersection
          min_length = if template.first
            template.index(nil) + 1
          elsif template.any? && first_intersection
            [first_intersection, template.index { |letter| !letter.nil? }].min + 1
          elsif first_intersection
            first_intersection
          else
            template.index { |letter| !letter.nil? } + 1
          end
          max_length = template.size
          rack.words(game.dictionary, min_length..max_length, template).map do |word|
            {
              word: word,
              square: starting_square,
              direction: direction
            }
          end
        else
          []
        end
      end
    end

    def template_at(square, direction)
      if direction == :horizontal
        prefix = square.sequence_left
        template = prefix + [nil]
        first_intersection = nil
        open_squares = 1
        next_square = square
        while open_squares <= rack.size && next_square = next_square.square_right
          open_squares += 1 if next_square.empty?
          if open_squares <= rack.size
            template << next_square.letter
            first_intersection ||= next_square.col - square.col if next_square.full? && next_square.full_square_up_or_down?
          end
        end
        [template, square.square_left(prefix.length), first_intersection]
      else
        prefix = square.sequence_up
        template = prefix + [nil]
        first_intersection = nil
        open_squares = 1
        next_square = square
        while open_squares <= rack.size && next_square = next_square.square_down
          open_squares += 1 if next_square.empty?
          if open_squares <= rack.size
            template << next_square.letter
            first_intersection ||= next_square.row - square.row if next_square.full? && next_square.full_square_left_or_right?
          end
        end
        [template, square.square_up(prefix.length), first_intersection]
      end
    end
  end
end