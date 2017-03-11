require 'set'

module Rabble
  class Dictionary
    def self.load(path)
      dictionary = self.new
      File.open(path).each do |word|
        dictionary << word.strip
      end
      dictionary
    end

    def initialize
      @words = Set.new
      @permutations = {}
    end

    def add(word)
      word = word.upcase
      sorted_word = Util.sorted_word(word)
      @permutations[sorted_word] ||= Set.new
      @permutations[sorted_word] << word
      @words << word
    end
    alias << add

    def permutations(word)
      @permutations[Util.sorted_word(word.upcase)] || []
    end
    alias [] permutations

    def include_permutations_of?(word)
      !self[word].empty?
    end

    def include_word?(word)
      @words.include?(word.upcase)
    end

    def num_permutation_groups
      @permutations.size
    end

    def num_words
      @words.size
    end
  end
end