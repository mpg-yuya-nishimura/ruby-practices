# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :throw_count, :score, :result_score

  def initialize(shots)
    @first_shot = Shot.new(shots[0])
    @second_shot = Shot.new(shots[1])
    @third_shot = Shot.new(shots[2])
    @throw_count = shots.size
    @score = total_score
  end

  def calc_result_score(frames, frame_number)
    @result_score = case throw_count
                    when 1
                      calc_single_frame(self, frames[frame_number + 1], frames[frame_number + 2])
                    when 2, 3
                      calc_multiple_frame(self, frames[frame_number + 1])
                    end
  end

  private

  def calc_single_frame(current_frame, next_frame, frame_after_next)
    return current_frame.score + next_frame.first_shot.score + next_frame.second_shot.score unless next_frame && frame_after_next && next_frame.throw_count == 1

    current_frame.score + next_frame.first_shot.score + frame_after_next.first_shot.score
  end

  def calc_multiple_frame(current_frame, next_frame)
    return current_frame.score + next_frame.first_shot.score if current_frame.score == STRIKE_SCORE && next_frame

    current_frame.score
  end

  def total_score
    [@first_shot, @second_shot, @third_shot].map(&:score).sum
  end
end
