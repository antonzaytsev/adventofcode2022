class Day12
  include Base

  START_POINT = 'S'
  END_POINT = 'E'
  DIRECTIONS = [
    [-1, 0], [0, 1], [1, 0], [0, -1]
  ]

  def part1
    setup

    paths = look_for_paths
    find_shortest_path_length(paths)
  end

  def part2
    setup

    paths = look_for_paths_part2
    find_shortest_path_length(paths)
  end

  private

  def setup
    build_chars_map
    find_starting_and_end_point
    set_bounds
  end

  def build_chars_map
    @weights = ('a'..'z').to_a.each_with_index.with_object({}) do |(el, index), obj|
      obj[el] = index
    end
    @weights[START_POINT] = @weights['a']
    @weights[END_POINT] = @weights['z']
  end

  def find_starting_and_end_point
    matrix.each_with_index do |chars, row_index|
      chars.each_with_index do |char, col_index|
        @start = [row_index, col_index] if char == START_POINT
        @end = [row_index, col_index] if char == END_POINT

        break if @start && @end
      end

      break if @start && @end
    end
  end

  def set_bounds
    @bounds = [[0, matrix.size-1], [0, matrix[0].size - 1]]
  end

  def look_for_paths(queues: {})
    queues[@start] = [@start] if queues[@start].nil?

    valid_paths = []

    processed_paths = 0
    start = Time.now

    while queues.size > 0 do
      print "valid_paths: #{valid_paths.size}; shortest path #{find_shortest_path_length valid_paths}; processed_paths #{processed_paths}; queue #{queues.size}; speed: #{(processed_paths / (Time.now - start)).floor} paths/second \r"

      point, path = queues.first
      queues.delete(point)

      DIRECTIONS.each do |direction|
        next_point = (0..1).map { |i| point[i] + direction[i] }

        next unless can_go_to_point?(point, next_point)
        next if already_been_there?(path, next_point)

        if next_point == @end
          valid_paths << path
          next
        end

        next_path = path + [next_point]
        next if queues[next_point] && queues[next_point].size <= next_path.size

        queues[next_point] = next_path
      end

      processed_paths += 1
    end

    valid_paths
  end

  def look_for_paths_part2
    queues = {}

    matrix.each.with_index do |chars, row_index|
      chars.each.with_index do |char, col_index|
        next if char != 'a'

        point = [row_index, col_index]
        queues[point] = [point]
      end
    end

    look_for_paths(queues: queues)
  end

  def point_to_char(point)
    matrix.dig(*point)
  end

  def matrix
    @matrix ||= input_rows.map(&:chars)
  end

  def matrix_heights
    @matrix_heights ||= matrix.each.with_index.with_object({}) do |(chars, row_index), obj|
      chars.each.with_index do |char, col_index|
        obj[[row_index, col_index]] = @weights.fetch(char)
      end
    end
  end

  def can_go_to_point?(current_point, destination_point)
    return false if out_of_bounds?(destination_point)

    current_point_value = matrix_heights.fetch(current_point)
    destination_point_value = matrix_heights.fetch(destination_point)

    destination_point_value - current_point_value <= 1
  end

  def out_of_bounds?(destination_point)
    !destination_point[0].between?(*@bounds[0]) || !destination_point[1].between?(*@bounds[1])
  end

  def already_been_there?(path, point)
    path.include?(point)
  end

  def draw_path(path)
    matrix_copy = matrix.dup.map(&:dup)

    matrix_copy.each do |chars|
      chars.each.with_index do |char, index|
        chars[index] = '·' if char != END_POINT
      end
    end

    path.each_cons(2) do |point_a, point_b|
      arrow =
        if point_a[0] > point_b[0]
          '^'
        elsif point_a[0] < point_b[0]
          'v'
        elsif point_a[1] > point_b[1]
          '<'
        else
          '>'
        end

      matrix_copy[point_a[0]][point_a[1]] = arrow
    end

    last_point = path.last
    if last_point != END_POINT
      matrix_copy[last_point[0]][last_point[1]] = '?'
    end

    puts matrix_copy.map(&:join).join("\n")
  end

  def find_shortest_path_length(paths)
    paths.map(&:size).min
  end
end