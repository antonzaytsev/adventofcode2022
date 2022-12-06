class Day6
  include Base

  def part1
    detect_first_uniq_characters(4)
  end

  def part2
    detect_first_uniq_characters(14)
  end

  private

  def detect_first_uniq_characters(uniq_chars_amount)
    input.split('').each_cons(uniq_chars_amount).with_index do |group, index|
      return index + uniq_chars_amount if group.uniq.size == uniq_chars_amount
    end
  end
end
