require 'rabble/bag'
require 'rabble/board'
require 'rabble/board_layout'
require 'rabble/dictionary'
require 'rabble/game'
require 'rabble/log'
require 'rabble/player'
require 'rabble/rack'
require 'rabble/tile_system'
require 'rabble/square'
require 'rabble/util'
require 'rabble/version'
require 'rabble/systems/standard'

module Rabble
  class Error < RuntimeError; end
  class IllegalPlacementError < Rabble::Error; end
end