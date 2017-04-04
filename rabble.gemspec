# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rabble/version"

Gem::Specification.new do |s|
  s.name     = 'rabble'
  s.version  = Rabble::VERSION

  s.summary  = "Ruby implementation of Scrabble"

  s.authors  = ["Erik Wiener"]
  s.email    = "erik.wiener@gmail.com"
  s.homepage = "https://github.com/ewiener/rabble"
  s.licenses = ['MIT']

  s.files    = Dir[
    "lib/**/*.rb",
    "bin/rabble",
    "dict/**/*.txt",
    "dict/README.md",
    "README.md",
    "LICENSE",
    "CHANGES",
    "Rakefile",
    "rabble.gemspec"
  ]

  s.require_path = 'lib'
end