module Rabble
  class Game
    attr_reader :dictionary, :tile_system, :board_layout, :bag, :board, :players, :next_player, :log

    def initialize(opts = {})
      @dictionary = opts[:dictionary] || Dictionary.load(opts[:word_file] || File.expand_path("../../../dict/en/standard.txt", __FILE__))
      @tile_system = TileSystem.new(Rabble::Systems::Standard::TILE_DATA)
      @board_layout = BoardLayout.new(Rabble::Systems::Standard::BOARD_DATA)
      @bag = Bag.new(@tile_system)
      @board = Board.new(@board_layout, @tile_system)
      @players = 1.upto(opts[:players] || 1).map.with_index { |i| Player.new(self, "Player #{i}") }
      @next_player = @players.first
      @log = Log.new
      @game_over = false
    end

    def reset
      bag.refill
      board.clear
      players.each(&:reset)
      log.clear
      @game_over = false
    end

    def play_next(print_play = true, print_board = true)
      return false if @game_over

      play = next_player.play
      if print_play
        play.print
        puts "#{bag.remaining_tiles} tiles remaining"
      end
      if print_board && !play.pass?
        board.print
      end
      @next_player = players[players.index(next_player) + 1] || players.first

      check_game_over

      true
    end

    def play_all(print_play = true, print_board = true)
      while play_next(print_play, print_board); end
    end

    def over?
      @game_over
    end

    def check_game_over
      if !over? && (any_played_out? || all_players_passed?)
        finalize
      end
    end

    def winner
      over? ? players.max_by { |p| p.score } : nil
    end

    def total_score
      players.reduce(0) { |total, p| total + p.score }
    end

    private

    def any_played_out?
      players.any? { |p| p.played_out? }
    end

    def all_players_passed?
      (1..players.size).all? { |i| log.entries[i * -1].pass? }
    end

    def finalize
      return if over?

      @game_over = true
      puts "Game Over"
      @players.each do |player|
        puts "#{player.name}: #{player.score}pts (Remaining tiles: #{player.rack.empty? ? "-" : player.rack.tiles.join})"
      end
      puts "Total score: #{total_score}"
    end
  end
end