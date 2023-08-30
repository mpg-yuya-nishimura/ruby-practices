# frozen_string_literal: true

require './shot'
require './frame'

STRIKE_SCORE = 10
TOTAL_GAME_COUNT = 10

class Game
  attr_reader :total_score

  def initialize(argv)
    shots = create_shots(argv)
    frames = create_frames(shots)
    @total_score = calc_total_score(frames)
  end

  private

  def create_shots(argv)
    argv.split(',').map { |score| Shot.new(score) }
  end

  def create_frames(shots)
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

    frame_result_points = []
    frames_score_points.each_with_index do |frame_scores, i|
      frame_result_points << if frame_scores.length == 1
                              if frames_score_points[i + 1] && frames_score_points[i + 2] && frames_score_points[i + 1].size == 1
                                frame_scores + [frames_score_points[i + 1][0]] + [frames_score_points[i + 2][0]]
                              else
                                frame_scores + frames_score_points[i + 1]&.first(2)
                              end
                            elsif frame_scores.length == 2
                              if frame_scores.sum == STRIKE_SCORE
                                frame_scores << frames_score_points[i + 1][0]
                              else
                                frame_scores
                              end
                            else
                              frame_scores
                            end
    end

    frames = frame_result_points.map { |frame_result_point| Frame.new(frame_result_point) }
  end

  def calc_total_score(frames)
    frames.sum { |frame| frame.frame_total }
  end
end
