# frozen_string_literal: true

class Frame
  attr_reader :frame_total

  def initialize(result_points)
    @result_points = result_points
    @frame_total = result_points.sum
  end
end
