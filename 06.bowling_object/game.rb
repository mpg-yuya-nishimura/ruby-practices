class Game
  def initialize(frame_result_points)
    @total_score = frame_result_points.sum
  end

  def show_total_score
    puts @total_score
  end
end
