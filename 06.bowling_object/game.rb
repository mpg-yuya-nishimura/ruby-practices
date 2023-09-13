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
      case frame.throw_count
      when 1
        frame.result_score = calc_single_frame(frame, frames[i + 1], frames[i + 2])
      when 2
        frame.result_score = calc_double_frame(frame, frames[i + 1])
      when 3
        frame.result_score = calc_double_frame(frame, frames[i + 1])
      else
        frame.result_score = frame
      end
    end
  end

  def create_frames(shots)
    frames_score_points = []
    created_new_frames = []
    tmp_scores = []
    shots.split(',').each do |shot|
      if tmp_scores.empty? && shot == 'X' && frames_score_points.size < TOTAL_GAME_COUNT - 1
        created_new_frames << Frame.new([shot])
        frames_score_points << [shot]
        tmp_scores = []
      else
        tmp_scores << shot
        if (tmp_scores.size == 2 && frames_score_points.size != TOTAL_GAME_COUNT - 1) || (tmp_scores.size == 3)
          created_new_frames << Frame.new(tmp_scores)
          frames_score_points << tmp_scores
          tmp_scores = [] unless frames_score_points.size == TOTAL_GAME_COUNT
        end
      end
    end
    created_new_frames
  end

  def calc_single_frame(current_frame, next_frame, frame_after_next)
    return current_frame.score + next_frame.first_shot.score + next_frame.second_shot.score unless next_frame && frame_after_next && next_frame.throw_count == 1

    current_frame.score + next_frame.first_shot.score + frame_after_next.first_shot.score
  end

  def calc_double_frame(current_frame, next_frame)
    return current_frame.score + next_frame.first_shot.score if current_frame.score == STRIKE_SCORE && next_frame

    current_frame.score
  end

  def calc_total_score(frames)
    frames.sum(&:result_score)
  end
end
