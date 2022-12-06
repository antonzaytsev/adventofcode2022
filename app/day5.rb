require 'typhoeus'
require 'pry'
require_relative './base.rb'

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

  def input_stacks
    # TODO: parse stacks from input
    {
      '1' => %w[N C R T M Z P],
      '2' => %w[D N T S B Z],
      '3' => %w[M H Q R F C T G],
      '4' => %w[G R Z],
      '5' => %w[Z N R H],
      '6' => %w[F H S W P Z L D],
      '7' => %w[W D Z R C G M],
      '8' => %w[S J F L H W Z Q],
      '9' => %w[S Q P W N],
    }
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
