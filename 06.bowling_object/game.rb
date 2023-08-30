# frozen_string_literal: true

require './shot'
require './frame'

STRIKE_SCORE = 10
TOTAL_GAME_COUNT = 10

class Game
  attr_reader :total_score

  def initialize(argv)
    shots = create_shots(argv)
    frames = create_frames(shots)
    result_frames = calc_frame_results(frames)
    @total_score = calc_total_score(result_frames)
  end

  private

  def create_shots(argv)
    argv.split(',').map { |score| Shot.new(score) }
  end

  def create_frames(shots)
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
    frames_score_points
  end

  def calc_frame_results(frames_score_points)
    frame_result_points = []

    frames_score_points.each_with_index do |frame_scores, i|
      frame_result_points << case frame_scores.length
                             when 1
                               calc_single_frame(frame_scores, frames_score_points[i + 1], frames_score_points[i + 2])
                             when 2
                               calc_double_frame(frame_scores, frames_score_points[i + 1])
                             else
                               frame_scores
                             end
    end

    frame_result_points.map { |frame_result_point| Frame.new(frame_result_point) }
  end

  def calc_single_frame(current_frame, next_frame, frame_after_next)
    return current_frame + next_frame&.first(2) unless next_frame && frame_after_next && next_frame.size == 1

    current_frame + [next_frame[0]] + [frame_after_next[0]]
  end

  def calc_double_frame(current_frame, next_frame)
    return current_frame + [next_frame[0]] if current_frame.sum == STRIKE_SCORE

    current_frame
  end

  def calc_total_score(frames)
    frames.sum(&:frame_total)
  end
end
