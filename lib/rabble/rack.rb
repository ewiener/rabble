module Rabble
  class Rack
    attr_reader :tiles, :max_tiles

    def initialize(tiles = [], max_tiles = 7)
      @tiles = []
      @max_tiles = max_tiles

      add_tiles(tiles[0..max_tiles])
    end

    def size
      tiles.size
    end

    def empty?
      tiles.empty?
    end

    def full?
      num_missing == 0
    end

    def num_missing
      max_tiles - tiles.size
    end

    def refill_from(bag)
      add_tiles(bag.draw(num_missing)) if !full?
    end

    def add_tiles(tiles)
      @tiles.concat(tiles[0..num_missing]).sort!
    end

    def remove_tiles(tiles)
      tiles.each do |tile|
        if index = @tiles.index(tile)
          @tiles.delete_at(index)
        end
      end
    end

    def clear
      tiles.clear
    end

    def words(dictionary, lengths, fixed_letters = [])
      lengths = (lengths..lengths) if lengths.is_a?(Fixnum)
      lengths.flat_map do |length|
        unless fixed_letters[length]
          words_of_length(dictionary, length, fixed_letters[0..length-1])
        end
      end.compact
    end

    private

    def words_of_length(dictionary, length, fixed_letters = [])
      fixed_sequence = fixed_letters.compact.sort
      if fixed_sequence.empty?
        tiles.combination(length).flat_map do |sequence|
          dictionary[sequence.join].to_a
        end.uniq
      else
        tiles.combination(length - fixed_sequence.size).flat_map do |sequence|
          dictionary[sequence.concat(fixed_sequence).sort.join].select do |word|
            fixed_letters.each_with_index.all? { |letter, position| !letter || word[position] == letter }
          end
        end.uniq
      end
    end
  end
end