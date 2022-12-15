class Day15
  include Base

  def part1(target_y)
    lines = find_ranges_for_y(target_y)
    lines.sum { |range| range.inject(&:-).abs }
  end

  def part2(search_area)
    beacon_position = nil

    (search_area[0]..search_area[1]).each do |target_y|
      lines = find_ranges_for_y(target_y, search_area: search_area)

      next if lines.size == 1

      beacon_position = [lines[1][0] - 1, target_y]
      break
    end

    beacon_tuning_frequency(beacon_position)
  end

  private

  def find_ranges_for_y(target_y, search_area: nil)
    lines = []

    parsed_rows.each do |row|
      y_diff_to_target = (row[:sensor][1] - target_y).abs
      next if y_diff_to_target > row[:distance]

      x_size = row[:distance] - y_diff_to_target
      line = [row[:sensor][0] - x_size, row[:sensor][0] + x_size].sort

      if search_area
        next unless intervals_overlap?(line, search_area)

        line[0] = [line[0], search_area[0]].max
        line[1] = [line[1], search_area[1]].min
      end

      lines << line
    end

    merge_overlapping_ranges(lines)
  end

  def intervals_overlap?(a, b)
    a[1] >= b[0] && a[0] <= b[1]
  end

  def merge_overlapping_ranges(ranges)
    ranges = ranges.sort_by(&:first)
    output = [ranges.shift]
    ranges.each do |range|
      last_item = output.last
      if last_item[1] >= range[0] - 1
        output[-1][1] = [range[1], last_item[1]].max
      else
        output.push(range)
      end
    end
    output
  end

  def parsed_rows
    @parsed_rows ||= input_rows.map do |row|
      matched = row.match(/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/)

      sensor = [matched[1].to_i, matched[2].to_i]
      beacon = [matched[3].to_i, matched[4].to_i]
      distance = distance_between(sensor, beacon)

      {
        sensor:,
        beacon:,
        distance:
      }
    end
  end

  def distance_between(point_a, point_b)
    (point_a[0] - point_b[0]).abs + (point_a[1] - point_b[1]).abs
  end

  def beacon_tuning_frequency(beacon)
    beacon[0] * 4000000 + beacon[1]
  end
end
