require 'json'

class Day9Draw
  include Base

  CANVAS_DIMENSIONS = [30, 30]

  def initialize(coordinates)
    init_canvas
    set_center
    put_on_canvas(coordinates)
  end

  def draw
    draw_canvas
    nil
  end

  private

  def init_canvas
    @canvas = []

    CANVAS_DIMENSIONS[0].times do
      row = []
      CANVAS_DIMENSIONS[1].times do
        row << '·'
      end

      @canvas << row
    end
  end

  def set_center
    @center = [CANVAS_DIMENSIONS[0]/2, CANVAS_DIMENSIONS[1]/2]
    @canvas[@center[0]][@center[1]] = 's'
  end

  def put_on_canvas(coordinates)
    coordinates.each_with_index do |coords, index|
      x = coords[0] + @center[0]
      y = coords[1] + @center[1]
      name = index
      name = 'H' if index == 0
      name = 'T' if index == coordinates.size - 1

      next unless ['.', 's'].include?(@canvas.fetch(y, x))

      @canvas[y][x] = name
    end
  end

  def draw_canvas
    system "clear"
    @canvas.reverse.each do |row|
      puts row.join(' ')
    end
  end
end
