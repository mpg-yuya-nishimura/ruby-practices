#!/usr/bin/env ruby

# frozen_string_literal: true

require './game'

require 'debug'

game = Game.new(ARGV[0])
puts game.total_score
