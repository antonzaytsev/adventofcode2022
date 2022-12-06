class Day5
  include Base

  def initialize
    @stacks = input_stacks
  end

  def part1
    @crate_mover_version = '9000'
    action_procedures
    top_of_each_stack_string
  end

  def part2
    @crate_mover_version = '9001'
    action_procedures
    top_of_each_stack_string
  end

  private

  def action_procedures
    input_procedures_parsed.each do |procedure|
      action_procedure(procedure)
    end
  end

  def action_procedure(procedure)
    if @crate_mover_version == '9000'
      procedure[:amount].times do
        crate = @stacks[procedure[:from]].pop
        @stacks[procedure[:to]] << crate
      end
    else
      crates = @stacks[procedure[:from]].pop(procedure[:amount])
      @stacks[procedure[:to]] += crates
    end
  end

  def top_of_each_stack_string
    @stacks.map { |_k, v| v.last }.join
  end

  # first take every 4th element starting from 2
  # transpose (rotate by 90 deg)
  # finally convert to hash
  def input_stacks
    input_rows[0..8].
      map { |row| row.split('').select.with_index { |el, index| index % 4 == 1} }.
      transpose.
      map(&:reverse).
      each_with_object({}) { |row, obj| obj[row.shift] = row.map(&:strip).reject(&:empty?) }
  end

  def input_procedures
    input_rows[10..-1]
  end

  def input_procedures_parsed
    input_procedures.map do |action|
      matches = action.match(/move (\d+) from (\d+) to (\d+)/)
      {
        amount: matches[1].to_i,
        from: matches[2],
        to: matches[3]
      }
    end
  end
end
