# frozen_string_literal: true

class Shot
  def initialize(score)
    @score = parse_shot_result(score)
  end

  def score
    @score
  end

  private

  def parse_shot_result(score)
    return 10 if score == 'X'

    score.to_i
  end
end
