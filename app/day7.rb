class Day7
  include Base

  class Dir
    attr_accessor :name, :elements, :parent_dir

    def initialize(name:, parent_dir:)
      @name = name
      @parent_dir = parent_dir
    end

    def size
      elements.sum(&:size)
    end

    def root?
      parent_dir.nil?
    end

    def dir?
      true
    end

    def dirs
      elements.select(&:dir?)
    end
  end

  class File
    attr_accessor :name, :size, :parent_dir

    def initialize(name:, size:, parent_dir:)
      @name = name
      @size = size
      @parent_dir = parent_dir
    end

    def dir?
      false
    end
  end

  def initialize
    @current_directory = nil
    @root = Dir.new(name: '/', parent_dir: nil)
  end

  def part1
    process_input
    find_dirs_sum_by_size(100_000)
  end

  def part2
    process_input
    directory_size_to_delete_to_have_total_size(40_000_000)
  end

  private

  def process_input
    commands.each do |command_with_output|
      execute_command(command_with_output)
    end
  end

  def commands
    input.split("$ ").reject(&:empty?).map(&:strip)
  end

  def execute_command(command_with_output)
    command, output = split_command_and_output(command_with_output)
    process_output(command, output)
  end

  def split_command_and_output(command_with_output)
    lines = command_with_output.split("\n")
    [lines.shift, lines]
  end

  def process_output(command, output)
    case command[0,2]
    when 'cd'
      change_directory(command[3..-1])
    when 'ls'
      persist_list_output(output)
    end
  end

  def change_directory(directory)
    @current_directory =
      if directory == '/'
        @root
      elsif directory == '..'
        @current_directory.parent_dir
      else
        @current_directory.dirs.detect { |el| el.name == directory }
      end
  end

  def persist_list_output(output)
    @current_directory.elements = output.map do |line|
      line_parts = line.split(' ')
      if line_parts[0] == 'dir'
        Dir.new(name: line_parts[1], parent_dir: @current_directory)
      else
        File.new(name: line_parts[1], size: line_parts[0].to_i, parent_dir: @current_directory)
      end
    end
  end

  def find_dirs_sum_by_size(target_size)
    all_dirs(@root).map(&:size).select { |size| size <= target_size }.sum
  end

  def all_dirs(dir)
    dir.dirs + dir.dirs.flat_map { |subdir| all_dirs(subdir) }
  end

  def directory_size_to_delete_to_have_total_size(target_free_space)
    need_to_free = @root.size - target_free_space
    all_dirs(@root).map(&:size).sort.detect { |size| size > need_to_free }
  end
end
