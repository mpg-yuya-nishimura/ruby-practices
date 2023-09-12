# frozen_string_literal: true
require './shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :throw_count, :score
  attr_accessor :result_score

  def initialize(shots)
    @first_shot = Shot.new(shots[0])
    @second_shot = Shot.new(shots[1])
    @third_shot = Shot.new(shots[2])
    @throw_count = shots.size
    @score = total_score
  end

  private

  def total_score
    @first_shot.score + @second_shot.score + @third_shot.score
  end
end
