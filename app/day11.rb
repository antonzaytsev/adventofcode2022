class Day11
  include Base

  class Monkey
    attr_accessor :item_inspected_times, :holding_items, :test_divisible_by, :if_test_true, :if_test_false, :operation
  end

  def initialize
  end

  def part1
    collect_starting_point
    process_rounds(20, decrease_worry_level: true)
    build_monkey_business_level
  end

  def part2
    collect_starting_point
    process_rounds(10_000, decrease_worry_level: false)
    build_monkey_business_level
  end

  private

  def collect_starting_point
    @monkeys = []
    monkey_inputs.each do |monkey_input|
      @monkeys << process_monkey_input(monkey_input)
    end
  end

  def monkey_inputs
    input.split("\n\n")
  end

  def process_monkey_input(monkey_input)
    rows = monkey_input.split("\n")
    items = rows[1].split(': ').last.split(', ').map(&:to_i)
    operation = Proc.new do |old|
      eval(rows[2].split('= ').last)
    end
    test_divisible_by = rows[3].split('by ').last.to_i
    if_test_true = rows[4].split('monkey ').last.to_i
    if_test_false = rows[5].split('monkey ').last.to_i

    monkey = Monkey.new
    monkey.item_inspected_times = 0
    monkey.holding_items = items
    monkey.test_divisible_by = test_divisible_by
    monkey.if_test_true = if_test_true
    monkey.if_test_false = if_test_false
    monkey.operation = operation

    monkey
  end

  def process_rounds(amount_of_rounds, decrease_worry_level:)
    common_div_test = @monkeys.map(&:test_divisible_by).inject(:*)
    amount_of_rounds.times do |round|
      process_round(decrease_worry_level: decrease_worry_level, round: round, common_div_test: common_div_test)
    end
  end

  def process_round(decrease_worry_level:, round:, common_div_test:)
    @monkeys.each do |monkey|
      monkey.holding_items.each do |holding_item_worry_level|
        monkey.item_inspected_times += 1

        new_worry_level = monkey.operation.call(holding_item_worry_level)
        new_worry_level = new_worry_level / 3 if decrease_worry_level
        throw_it_to_monkey =
          if new_worry_level % monkey.test_divisible_by == 0
            monkey.if_test_true
          else
            monkey.if_test_false
          end

        # allow manage too high worry level
        new_worry_level = new_worry_level % common_div_test

        @monkeys[throw_it_to_monkey].holding_items << new_worry_level
      end
      monkey.holding_items = []
    end
  end

  def build_monkey_business_level
    @monkeys.map(&:item_inspected_times).sort.last(2).inject(:*)
  end
end