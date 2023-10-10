# frozen_string_literal: true

class Shot
  attr_reader :score

  def initialize(score)
    @score = parse_shot_score(score)
  end

  private

  def parse_shot_score(score)
    return 10 if score == 'X'

    score.to_i
  end
end
