require 'typhoeus'
require 'pry'
require './base.rb'

class Day2
  include Base

  SHAPES = {
    'A' => :rock,
    'X' => :rock,
    'B' => :paper,
    'Y' => :paper,
    'C' => :scissors,
    'Z' => :scissors,
  }

  SHAPE_POINTS = {
    rock: 1,
    paper: 2,
    scissors: 3
  }

  SHAPE_PRIORITY = {
    paper: :rock,
    scissors: :paper,
    rock: :scissors
  }

  PART2_SHAPES = {
    'X' => :lose,
    'Y' => :draw,
    'Z' => :win
  }

  def initialize
    @score = 0
  end

  def part1
    input_rows.each do |round|
      shapes = transform_letters_to_shapes(round.split(' '))
      add_shape_points(shapes)
      add_winner_points(shapes)
    end

    @score
  end

  def part2
    input_rows.each do |round|
      shapes = transform_letters_to_shapes_part2(round.split(' '))
      add_shape_points(shapes)
      add_winner_points(shapes)
    end

    @score
  end

  private

  def transform_letters_to_shapes(shapes)
    shapes.map do |shape|
      SHAPES[shape]
    end
  end

  def transform_letters_to_shapes_part2(shapes)
    [
      SHAPES[shapes[0]],
      find_shape_part2(shapes[1], SHAPES[shapes[0]])
    ]
  end

  def find_shape_part2(shape, opponent_shape)
    case PART2_SHAPES[shape]
    when :lose then SHAPE_PRIORITY[opponent_shape]
    when :draw then opponent_shape
    when :win then (SHAPE_PRIORITY.keys - [opponent_shape, SHAPE_PRIORITY[opponent_shape]]).first
    end
  end

  def add_shape_points(shapes)
    @score += SHAPE_POINTS[shapes[1]]
  end

  def add_winner_points(shapes)
    @score +=
      if draw(shapes)
        3
      elsif winner(shapes)
        6
      else
        0
      end
  end

  def draw(shapes)
    shapes[0] == shapes[1]
  end

  def winner(shapes)
    SHAPE_PRIORITY[shapes[1]] == shapes[0]
  end
end
