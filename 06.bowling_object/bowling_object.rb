#!/usr/bin/env ruby

# frozen_string_literal: true

require 'debug'

require './game'

game = Game.new(ARGV[0])
puts game.total_score
