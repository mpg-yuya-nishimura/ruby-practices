# frozen_string_literal: true

require './shot'

STRIKE_SCORE = 10
SPARE_SCORE = 10

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :score

  def initialize(shots)
    @first_shot = Shot.new(shots[0])
    @second_shot = Shot.new(shots[1])
    @third_shot = Shot.new(shots[2])
    @score = total_score
  end

  def result_score(next_frame, after_next_frame)
    @score = if strike? && next_frame
               calc_strike_frame(next_frame, after_next_frame)
             elsif spare? && next_frame
               calc_spare_frame(next_frame)
             else
               score
             end
  end

  def spare?
    score == SPARE_SCORE
  end

  def strike?
    first_shot.score == STRIKE_SCORE
  end

  private

  def calc_strike_frame(next_frame, after_next_frame)
    common_score = score + next_frame.first_shot.score
    return common_score + next_frame.second_shot.score if !after_next_frame || !next_frame.strike?

    common_score + after_next_frame.first_shot.score
  end

  def calc_spare_frame(next_frame)
    score + next_frame.first_shot.score
  end

  def total_score
    [@first_shot, @second_shot, @third_shot].map(&:score).sum
  end
end
