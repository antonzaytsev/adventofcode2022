class Day10
  include Base

  def initialize
    @x = 1
    @cycles = []
  end

  def part1
    process_instructions
    result_signal_strength
  end

  def part2
    process_instructions
    draw_output
  end

  def part2_letters
    process_instructions
    output = draw_output
    letters_from_output(output)
  end

  private

  def remember_cycle_value
    @cycles << @x
  end

  def process_instructions
    input_rows.each do |instruction|
      process_instruction(instruction)
    end
  end

  def process_instruction(instruction_and_value)
    instruction, value = instruction_and_value.split(' ')

    if instruction == 'addx'
      remember_cycle_value
      remember_cycle_value
      @x += value.to_i
    else
      remember_cycle_value
    end
  end

  def result_signal_strength
    [20, 60, 100, 140, 180, 220].sum do |cycle|
      @cycles[cycle-1] * cycle
    end
  end

  def draw_output
    output = []

    @cycles.each.with_index do |sprite_position, cycle|
      output << draw_char(cycle, sprite_position)
    end

    output.each_slice(40).map { |slice| slice.join }.join("\n")
  end

  def draw_char(cycle, sprite_position)
    return '#' if (cycle % 40 + 1).between?(sprite_position, sprite_position+2)

    '.'
  end

  ALPHABET_6 = {
    ".##.\n#..#\n#..#\n####\n#..#\n#..#": "A",
    "###.\n#..#\n###.\n#..#\n#..#\n###.": "B",
    ".##.\n#..#\n#...\n#...\n#..#\n.##.": "C",
    "####\n#...\n###.\n#...\n#...\n####": "E",
    "####\n#...\n###.\n#...\n#...\n#...": "F",
    ".##.\n#..#\n#...\n#.##\n#..#\n.###": "G",
    "#..#\n#..#\n####\n#..#\n#..#\n#..#": "H",
    ".###\n..#.\n..#.\n..#.\n..#.\n.###": "I",
    "..##\n...#\n...#\n...#\n#..#\n.##.": "J",
    "#..#\n#.#.\n##..\n#.#.\n#.#.\n#..#": "K",
    "#...\n#...\n#...\n#...\n#...\n####": "L",
    ".##.\n#..#\n#..#\n#..#\n#..#\n.##.": "O",
    "###.\n#..#\n#..#\n###.\n#...\n#...": "P",
    "###.\n#..#\n#..#\n###.\n#.#.\n#..#": "R",
    ".###\n#...\n#...\n.##.\n...#\n###.": "S",
    "#..#\n#..#\n#..#\n#..#\n#..#\n.##.": "U",
    "#...\n#...\n.#.#\n..#.\n..#.\n..#.": "Y",
    "####\n...#\n..#.\n.#..\n#...\n####": "Z",
  }

  def letters_from_output(output)
    letters = []
    output.split("\n").each do |row|
      row.chars.each_slice(5).with_index do |chars, index|
        letters[index] ||= []
        letters[index] << chars.first(4).join
      end
    end
    letters.map do |letters_array|
      ALPHABET_6.fetch(letters_array.join("\n").to_sym)
    end.join
  end
end