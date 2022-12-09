require 'json'
require 'io/console'

class Day9
  include Base

  def part1(draw = false)
    process_rope(2, draw)
  end

  def part2(draw = false)
    process_rope(10, draw)
  end

  private

  def process_rope(rope_length, draw)
    initialize_rope(rope_length)

    @rope_position_history = []
    save_rope_position_history

    input_rows.each do |row|
      direction, steps_amount = row.split(' ')
      move_rope_to(direction: direction, steps_amount: steps_amount.to_i)
    end

    draw_history(draw)

    @rope_position_history.map(&:last).uniq.size
  end

  def initialize_rope(amount)
    @rope_length = amount

    @start_position = [0, 0]
    @current_rope_position = amount.times.map { @start_position.dup }
  end

  def move_rope_to(direction:, steps_amount:)
    head = @current_rope_position[0]

    steps_amount.times do
      case direction
      when 'L' then head[0] -= 1
      when 'R' then head[0] += 1
      when 'U' then head[1] += 1
      when 'D' then head[1] -= 1
      end

      rope_follows_head

      save_rope_position_history
    end
  end

  def rope_follows_head
    (0..@rope_length-1).to_a.each_cons(2)  do |knot_1_index, knot_2_index|
      next if knot_width_correct?(knot_1_index, knot_2_index)

      knot_follows_parent(knot_1_index, knot_2_index)
    end
  end

  def save_rope_position_history
    @rope_position_history << JSON.parse(@current_rope_position.to_json)
  end

  def knot_width_correct?(knot_1_index, knot_2_index)
    (@current_rope_position[knot_1_index][0] - @current_rope_position[knot_2_index][0]).abs <= 1 &&
      (@current_rope_position[knot_1_index][1] - @current_rope_position[knot_2_index][1]).abs <= 1
  end

  def knot_follows_parent(knot_1_index, knot_2_index)
    k1 = @current_rope_position[knot_1_index]
    k2 = @current_rope_position[knot_2_index]

    if k1[0] == k2[0]
      k2[1] += (k1[1] - k2[1])/2
    elsif k1[1] == k2[1]
      k2[0] += (k1[0] - k2[0])/2
    else
      if k1[0] - k2[0] >= 1
        k2[0] += 1
      elsif k1[0] - k2[0] <= -1
        k2[0] += -1
      end

      if k1[1] - k2[1] >= 1
        k2[1] += 1
      elsif k1[1] - k2[1] <= -1
        k2[1] += -1
      end
    end
  end

  def draw_history(draw)
    return unless draw

    if draw == :manual
      current_state = @rope_position_history.length - 10
      Day9Draw.new(@rope_position_history[current_state]).draw

      while true
        user_input = $stdin.getch
        case user_input
        when 'q'
          break
        when 'b'
          binding.pry
        when 'n'
          current_state = [current_state + 1, @rope_position_history.size-1].min
          Day9Draw.new(@rope_position_history[current_state]).draw if @rope_position_history[current_state]
        when 'p'
          current_state = [current_state - 1, 0].max
          Day9Draw.new(@rope_position_history[current_state]).draw if @rope_position_history[current_state]
        end
      end
    else
      @rope_position_history.each do |rope_position|
        Day9Draw.new(rope_position).draw
        sleep(0.3)
      end
    end
  end
end
