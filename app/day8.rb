class Day8
  include Base

  def part1
    @cell_visibility = {}
    loop_matrix_and_mark_visible(matrix)
    loop_matrix_and_mark_visible(matrix.transpose, transposed: true)
    @cell_visibility.size
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
    input_matrix.each.with_index do |row, row_index|
      row.each.with_index do |cell, column_index|
        next unless tree_visible?(row, column_index, cell)

        key = [row_index, column_index]
        key = key.reverse if transposed
        @cell_visibility[key] = true
      end
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
