class Day4
  include Base

  def part1
    count_pairs do |first, second|
      (first[0] >= second[0] && first[1] <= second[1]) || (first[0] <= second[0] && first[1] >= second[1])
    end
  end

  def part2
    count_pairs do |first, second|
      second[0].between?(*first) || second[1].between?(*first) || first[0].between?(*second) || first[1].between?(*second)
    end
  end

  private

  def count_pairs
    input_rows.sum do |row|
      row.split(',').map { |el| el.split('-').map(&:to_i) }.each_cons(2).count do |first, second|
        yield first, second
      end
    end
  end
end
