#!/usr/bin/env ruby

# frozen_string_literal: true

require 'debug'
require './shot'
require './frame'
require './game'

STRIKE_SCORE = 10
TOTAL_GAME_COUNT = 10

shots = ARGV[0].split(',').map { |score| Shot.new(score) }

frames_score_points = []
tmp_scores = []
shots.each do |shot|
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

frame_result_points = []
frames_score_points.each_with_index do |frame_scores, i|
  frame_result_points << if frame_scores.length == 1
                           if frames_score_points[i + 1] && frames_score_points[i + 2] && frames_score_points[i + 1].size == 1
                             frame_scores + [frames_score_points[i + 1][0]] + [frames_score_points[i + 2][0]]
                           else
                             frame_scores + frames_score_points[i + 1]&.first(2)
                           end
                         elsif frame_scores.length == 2
                           if frame_scores.sum == STRIKE_SCORE
                             frame_scores << frames_score_points[i + 1][0]
                           else
                             frame_scores
                           end
                         else
                           frame_scores
                         end
end

frames = frame_result_points.map { |frame_result_point| Frame.new(frame_result_point) }
result_frames_scores = frames.map { |frame| frame.frame_result_points }

game = Game.new(result_frames_scores)
game.show_total_score
