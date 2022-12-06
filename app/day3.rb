require 'typhoeus'
require 'pry'
require_relative './base.rb'

class Day3
  include Base

  def part1
    priorities = input_rows.map do |row|
      compartments = divide_row(row)
      char = item_appeared_in_both_compartments(compartments)
      [char, item_priority(char)]
    end

    priorities.sum(&:last)
  end

  def part2
    priorities = input_rows.each_slice(3).map do |rows|
      item = rows.map(&:chars).reduce { |list, row| list & row }.first
      [item, item_priority(item)]
    end

    priorities.sum(&:last)
  end

  private

  def divide_row(row)
    [
      row[0..row.length/2-1],
      row[row.length/2..-1]
    ]
  end

  def item_appeared_in_both_compartments(compartments)
    (compartments[0].chars & compartments[1].chars).first
  end

  def item_priority(char)
    ord = char.ord
    ord - (ord > 96 ? 96 : 38)
  end
end
