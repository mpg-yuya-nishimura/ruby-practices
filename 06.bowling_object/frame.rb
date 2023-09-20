# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :score, :result_score

  def initialize(shots)
    @first_shot = Shot.new(shots[0])
    @second_shot = Shot.new(shots[1])
    @third_shot = Shot.new(shots[2])
    @score = total_score
  end

  def calc_result_score(next_frame, after_next_frame)
    @result_score = if first_shot.score == 10 && next_frame
      calc_single_frame(next_frame, after_next_frame)
    else
      calc_multiple_frame(next_frame)
    end
  end

  private

  def calc_single_frame(next_frame, after_next_frame)
    return score + next_frame.first_shot.score + next_frame.second_shot.score unless next_frame && after_next_frame && next_frame.first_shot.score == 10

    score + next_frame.first_shot.score + after_next_frame.first_shot.score
  end

  def calc_multiple_frame(next_frame)
    return score + next_frame.first_shot.score if score == STRIKE_SCORE && next_frame

    score
  end

  def total_score
    [@first_shot, @second_shot, @third_shot].map(&:score).sum
  end
end
