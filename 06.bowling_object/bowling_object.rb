#!/usr/bin/env ruby

# frozen_string_literal: true

require 'debug'
require './shot.rb'
require './frame.rb'

STRIKE_SCORE = 10
TOTAL_GAME_COUNT = 10

parsed_score_numbers = ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }

all_shots = parsed_score_numbers.map { |parsed_score_number| Shot.new(parsed_score_number) }

frames_score_points = []
tmp_scores = []
all_shots.each do |shot|
  if tmp_scores.empty? && shot.score == STRIKE_SCORE && frames_score_points.size < TOTAL_GAME_COUNT - 1
    frames_score_points << [shot.score]
    tmp_scores = []
  else
    tmp_scores << shot.score
    if tmp_scores.size == 2
      frames_score_points << tmp_scores
      tmp_scores = [] unless frames_score_points.size == TOTAL_GAME_COUNT
    end
  end
end

all_frames = frames_score_points.map { |frames_score_point| Frame.new(frames_score_point) }
