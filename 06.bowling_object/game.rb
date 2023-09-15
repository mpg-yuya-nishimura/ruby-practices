# frozen_string_literal: true

require './shot'
require './frame'

STRIKE_SCORE = 10
TOTAL_GAME_COUNT = 10

class Game
  attr_reader :total_score

  def initialize(shots)
    result_frames = calc_frame_results(shots)
    @total_score = calc_total_score(result_frames)
  end

  private

  def calc_frame_results(shots)
    frames = create_frames(shots)

    frames.each_with_index do |frame, i|
      frame.calc_result_score(frames, i)
    end
  end

  def create_frames(shots)
    separate_frames(shots).map { |frames_score_point| Frame.new(frames_score_point) }
  end

  def separate_frames(shots)
    frames_score_points = []
    tmp_scores = []

    shots.split(',').each do |shot|
      if tmp_scores.empty?
        add_single_shot_score(shot, frames_score_points, tmp_scores)
      else
        add_multiple_shot_scores(shot, frames_score_points, tmp_scores)
      end
    end

    frames_score_points
  end

  def add_single_shot_score(shot, frames_score_points, tmp_scores)
    if shot == 'X' && frames_score_points.size < TOTAL_GAME_COUNT - 1
      frames_score_points << [shot]
    else
      tmp_scores << shot
    end
  end

  def add_multiple_shot_scores(shot, frames_score_points, tmp_scores)
    tmp_scores << shot
    if tmp_scores.size == 2
      frames_score_points << tmp_scores
      tmp_scores = [] unless frames_score_points.size == TOTAL_GAME_COUNT
    end
  end

  def calc_total_score(frames)
    frames.sum(&:result_score)
  end
end
