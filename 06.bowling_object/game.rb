# frozen_string_literal: true

require './shot'
require './frame'

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
      frame.result_score(frames[i + 1], frames[i + 2])
    end
  end

  def create_frames(shots)
    separate_frames(shots).map { |frames_score_point| Frame.new(frames_score_point) }
  end

  def separate_frames(shots)
    frames_score_points = []
    tmp_scores = []

    shots.split(',').each do |shot|
      tmp_scores << shot
      if frames_score_points.size < TOTAL_GAME_COUNT
        if tmp_scores.size >= 2 || shot == 'X'
          frames_score_points << tmp_scores.dup
          tmp_scores.clear
        end
      else
        frames_score_points.last << shot
      end
    end

    frames_score_points
  end

  def calc_total_score(frames)
    frames.sum(&:score)
  end
end
