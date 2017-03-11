module Rabble
  class TileSystem
    def initialize(tile_data = nil)
      @tile_data = tile_data || Rabble::Systems::Standard::TILE_DATA
    end

    def letters
      @tile_data.keys
    end

    def points(letter)
      @tile_data[letter] ? @tile_data[letter][:points] : 0
    end

    def tiles(letter)
      @tile_data[letter] ? @tile_data[letter][:tiles] : 0
    end

    def score(word)
      word.chars.reduce(0) { |sum, letter| sum + points(letter) }
    end
  end
end