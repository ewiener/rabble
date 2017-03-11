module Rabble
  class Bag
    def initialize(tile_system)
      @tile_system = tile_system
      refill
    end

    def refill
      @tiles = @tile_system.letters.flat_map do |letter|
        [letter] * @tile_system.tiles(letter)
      end.shuffle!
    end

    def draw(count)
      @tiles.shift(count)
    end

    def remaining_tiles
      @tiles.size
    end
  end
end