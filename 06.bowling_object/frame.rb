# frozen_string_literal: true

class Frame
  attr_reader :frame_total

  def initialize(result_points)
    @result_points = result_points
    @frame_total = result_points.sum
  end

  class << self
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
  end
end
