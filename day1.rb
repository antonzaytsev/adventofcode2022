require 'typhoeus'
require './base.rb'

class Day1
  include Base

  def initialize
    @input = 'https://adventofcode.com/2022/day/1/input'
    @input_local_file = 'day1.txt'
  end

  def part1
    input.split("\n\n").map { |item| item.split("\n").sum(&:to_i) }.max
  end

  def part2
    input.split("\n\n").lazy.map { |item| item.split("\n").sum(&:to_i) }.sort.reverse.take(3).sum
  end
end

puts Day1.new.part1
puts Day1.new.part2
