require 'typhoeus'
require './base.rb'

class Day1
  include Base

  def part1
    input.split("\n\n").map { |item| item.split("\n").sum(&:to_i) }.max
  end

  def part2
    input.split("\n\n").lazy.map { |item| item.split("\n").sum(&:to_i) }.sort.reverse.take(3).sum
  end
end
