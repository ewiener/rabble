module Rabble
  class Log
    class Entry < Struct.new(:player, :word, :square, :direction, :score, :placed_letters)
      def pass?
        word.nil?
      end

      def print
        if pass?
          puts "#{player.name}: Pass"
        else
          puts "#{player.name}: #{word} @ R#{square.row}xC#{square.col}#{direction.to_s[0]} (#{placed_letters.join}) #{score}pts"
        end
      end
    end

    attr_reader :entries

    def initialize
      @entries = []
    end

    def log(player, word, square = nil, direction = nil, score = nil, placed_letters = nil)
      Entry.new(player, word, square, direction, score, placed_letters).tap do |entry|
        entries << entry
      end
    end

    def clear
      @entries = []
    end
  end
end