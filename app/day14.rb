class Day14
  include Base

  POURING_POINT = [500,0]
  SYMBOLS = {air: '·', rock: '#', sand: 'o'}

  class Cave
    attr_accessor :rocks, :sands
    attr_reader :lowest_rock_y

    def initialize
      @rocks = Set.new
      @sands = Set.new
    end

    def air?(point)
      !rock?(point) && !sand?(point)
    end

    def rock?(point)
      @rocks.include?(point) || floor?(point)
    end

    def sand?(point)
      @sands.include?(point)
    end

    def define_lowest_rock_y
      @lowest_rock_y = rocks.map(&:last).max
      @floor = @lowest_rock_y + 2
    end

    def symbol(point)
      return SYMBOLS[:rock] if rock?(point)
      return SYMBOLS[:sand] if sand?(point)
      SYMBOLS[:air]
    end

    def floor?(point)
      @floor == point[1]
    end
  end

  def part1
    init_cave_with_rocks
    throw_sands
    amount_of_sand_in_cave
  end

  def part2
    init_cave_with_rocks
    throw_sands_part2
    amount_of_sand_in_cave
  end

  private

  def init_cave_with_rocks
    @cave = Cave.new
    add_rocks_to_cave
    @cave.define_lowest_rock_y
  end

  def input_data
    @input_data ||= input_rows.map do |row|
      row.split(' -> ').map { |item| item.split(',').map(&:to_i) }
    end
  end

  def amount_of_sand_in_cave
    @cave.sands.size
  end

  def add_rocks_to_cave
    input_data.each do |row|
      row.each_cons(2) do |start_point, end_point|
        points_x = [start_point[0], end_point[0]]
        points_y = [start_point[1], end_point[1]]

        (points_x.min..points_x.max).each do |point_x|
          (points_y.min..points_y.max).each do |point_y|
            @cave.rocks << [point_x, point_y]
          end
        end
      end
    end
  end

  def throw_sands
    loop do
      break unless throw_sand
    end
  end

  def throw_sand
    sand_point = POURING_POINT
    sand_in_rest = false

    loop do
      sand_in_rest = false
      cell_candidate = sand_point.dup
      cell_candidate[1] += 1

      break if cell_candidate[1] > @cave.lowest_rock_y

      if @cave.air?(cell_candidate)
        sand_point = cell_candidate
        next
      end

      cell_candidate[0] -= 1
      if @cave.air?(cell_candidate)
        sand_point = cell_candidate
        next
      end

      cell_candidate[0] = sand_point[0] + 1
      if @cave.air?(cell_candidate)
        sand_point = cell_candidate
        next
      end

      @cave.sands << sand_point
      sand_in_rest = true
      break
    end

    sand_in_rest
  end

  def throw_sands_part2
    loop do
      throw_sand_part2
      break if @cave.sands.include?(POURING_POINT)
    end
  end

  def throw_sand_part2
    sand_point = POURING_POINT

    loop do
      next_cell = sand_point.dup

      # check bottom
      next_cell[1] += 1

      if @cave.floor?(next_cell)
        @cave.sands << sand_point
        break
      end

      if @cave.air?(next_cell)
        sand_point = next_cell
        next
      end

      # check bottom left
      next_cell[0] -= 1

      if @cave.floor?(next_cell)
        @cave.sands << sand_point
        break
      end

      if @cave.air?(next_cell)
        sand_point = next_cell
        next
      end

      # check bottom right
      next_cell[0] = sand_point[0] + 1

      if @cave.floor?(next_cell)
        @cave.sands << sand_point
        break
      end

      if @cave.air?(next_cell)
        sand_point = next_cell
        next
      end

      # nowhere to move else
      @cave.sands << sand_point
      break
    end
  end

  def draw_cave!
    output = []

    cave_points = @cave.rocks.to_a + @cave.sands.to_a

    top_y = 0
    bottom_y = cave_points.map(&:last).max + 1
    left_x = cave_points.map(&:first).min - 1
    right_x = cave_points.map(&:first).max + 1

    (top_y..bottom_y).each do |point_y|
      row = []
      (left_x..right_x).each do |point_x|
        row << @cave.symbol([point_x, point_y])
      end
      output << row.join
    end

    system "clear"
    puts output.join("\n") + "\t"
  end
end