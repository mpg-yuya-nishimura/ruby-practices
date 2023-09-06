# frozen_string_literal: true

require './shot'
require './frame'

STRIKE_SCORE = 10
TOTAL_GAME_COUNT = 10

class Game
  attr_reader :total_score

  def initialize(argv)
    shots = create_shots(argv)
    game_scores = create_game_scores(shots)
    result_frames = Frame.calc_frame_results(game_scores)
    @total_score = calc_total_score(result_frames)
  end

  private

  def create_shots(argv)
    argv.split(',').map { |score| Shot.new(score) }
  end

  def create_game_scores(shots)
    frames_score_points = []
    tmp_scores = []
    shots.each do |shot|
      if tmp_scores.empty? && shot.score == STRIKE_SCORE && frames_score_points.size < TOTAL_GAME_COUNT - 1
        frames_score_points << [shot.score]
        tmp_scores = []
      else
        tmp_scores << shot.score
        if tmp_scores.size == 2
          frames_score_points << tmp_scores
          tmp_scores = [] unless frames_score_points.size == TOTAL_GAME_COUNT
        end
      end
    end
    frames_score_points
  end

  def calc_total_score(frames)
    frames.sum(&:frame_total)
  end
end
