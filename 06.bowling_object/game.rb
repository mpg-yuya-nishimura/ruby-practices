# frozen_string_literal: true

require './shot'
require './frame'

TOTAL_GAME_COUNT = 10

class Game
  attr_reader :total_score

  def initialize(shots)
    @total_score = calc_total_results(shots)
  end

  private

  def calc_total_results(shots)
    frames = create_frames(shots)

    total_score = 0
    frames.each_with_index do |frame, i|
      total_score += frame.result_score(frames[i + 1], frames[i + 2])
    end

    total_score
  end

  def create_frames(shots)
    separate_frames(shots).map { |frames_score_point| Frame.new(frames_score_point) }
  end

  def separate_frames(shots)
    frames_score_points = []
    tmp_scores = []

    shots.split(',').each do |shot|
      tmp_scores << shot
      if frames_score_points.size >= TOTAL_GAME_COUNT
        frames_score_points.last << shot
      elsif tmp_scores.size >= 2 || shot == 'X'
        frames_score_points << tmp_scores.dup
        tmp_scores.clear
      end
    end

    frames_score_points
  end
end
