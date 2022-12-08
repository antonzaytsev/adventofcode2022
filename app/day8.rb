class Day8
  include Base

  def part1
    visible_cells = Set.new
    visible_cells += loop_matrix_and_mark_visible(matrix)
    visible_cells += loop_matrix_and_mark_visible(matrix.transpose, transposed: true)
    visible_cells.size
  end

  def part2
    @visible_trees_amount_by_cell = Hash.new { |hash, key| hash[key] = [] }
    loop_matrix_and_count_visible(matrix)
    loop_matrix_and_count_visible(matrix.transpose, transposed: true)
    find_tree_with_most_visible_other_trees
  end

  private

  def matrix
    @matrix ||= input_rows.map { |row| row.split('').map(&:to_i) }
  end

  def loop_matrix_and_mark_visible(input_matrix, transposed: false)
    input_matrix.each.with_index.with_object(Set.new) do |(row, row_index), set|
      set = set.merge loop_to_find_visible_cells(row, row_index: row_index, direction: :straight, transposed: transposed)
      set = set.merge loop_to_find_visible_cells(row, row_index: row_index, direction: :reverse, transposed: transposed)
    end
  end

  def loop_to_find_visible_cells(row, row_index:, direction:, transposed:)
    enumerator =
      if direction == :straight
        row.each.with_index
      else
        row.to_enum.with_index.reverse_each
      end

    prev_max_cell = nil
    enumerator.each_with_object(Set.new) do |(cell, column_index), set|
      key = [row_index, column_index]
      key = key.reverse if transposed

      set << key if prev_max_cell.nil? || prev_max_cell < cell

      prev_max_cell = [cell, prev_max_cell || 0].max
    end
  end

  def tree_visible?(row, column_index, cell)
    left_trees = row[0...column_index]
    right_trees = row[(column_index + 1)..-1]

    left_trees.none? || left_trees.all? { |tree| tree < cell } ||
      right_trees.none? || right_trees.all? { |tree| tree < cell }
  end

  def loop_matrix_and_count_visible(input_matrix, transposed: false)
    input_matrix.each.with_index do |row, row_index|
      row.each.with_index do |cell, column_index|
        left_trees = row[0...column_index].reverse
        right_trees = row[(column_index + 1)..-1]

        visible_trees_left = count_visible_trees(left_trees, cell)
        visible_trees_right = count_visible_trees(right_trees, cell)

        key = [row_index, column_index]
        key = key.reverse if transposed

        @visible_trees_amount_by_cell[key] += [visible_trees_left, visible_trees_right]
      end
    end
  end

  def find_tree_with_most_visible_other_trees
    @visible_trees_amount_by_cell.values.map { |els| els.inject(:*) }.max
  end

  def count_visible_trees(trees, cell)
    return 0 if trees.empty?
    count = 0
    trees.each do |el|
      count += 1
      break if el >= cell
    end
    count
  end
end
