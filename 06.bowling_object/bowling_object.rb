#!/usr/bin/env ruby

# frozen_string_literal: true

require 'debug'
require './shot.rb'

STRIKE_SCORE = 10
TOTAL_GAME_COUNT = 10

parsed_score_numbers = ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }

all_shots = parsed_score_numbers.map { |parsed_score_number| Shot.new(parsed_score_number) }
