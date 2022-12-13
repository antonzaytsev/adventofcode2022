class Day13
  include Base

  def part1
    groups.map.with_index do |group_elements, index|
      next index+1 if items_in_right_order(group_elements) == -1
      0
    end.sum
  end

  def part2
    flat_groups = groups.flatten(1)
    decoder_packets = [[[2]], [[6]]]
    groups_with_divider_packets = flat_groups + decoder_packets
    sorted_groups = groups_with_divider_packets.sort do |item_a, item_b|
      items_in_right_order([item_a, item_b])
    end
    sorted_groups = sorted_groups

    decoder_packets.
      map { |decoder_packet| sorted_groups.index(decoder_packet) + 1 }.
      inject(:*)
  end

  private

  def groups
    input.split("\n\n").map do |groups|
      groups.split("\n").map { |row| JSON.parse(row) }
    end
  end

  def items_in_right_order(items)
    there_is_array = items.any? { |el| el.is_a?(Array) }
    items = items.map { |el| el.is_a?(Array) ? el : [el] } if there_is_array

    if there_is_array
      arrays_sorted_correct?(items)
    else
      compare_integers(items)
    end
  end

  def arrays_sorted_correct?(items)
    result = nil

    max_items = items.map(&:size).max
    max_items.times do |index|
      pair_to_compare = items.map { |el| el[index] }

      # if one array have more elements than another
      result = -1 if !pair_to_compare[0]
      result = 1 if !pair_to_compare[1]
      break if result == 1 || result == -1

      result = items_in_right_order(pair_to_compare)
      break if result == 1 || result == -1
    end

    result
  end

  def compare_integers(items)
    items.inject(&:<=>)
  end
end