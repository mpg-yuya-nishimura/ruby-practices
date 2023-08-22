# frozen_string_literal: true

class Frame
  def initialize(frame_result_point)
    @frame_result_points = frame_result_point.sum
  end

  def frame_result_points
    @frame_result_points
  end
end
