# frozen_string_literal: true

class Frame
  def initialize(frame_result_point)
    @frame_total = frame_result_point.sum
  end

  def frame_total
    @frame_total
  end
end
