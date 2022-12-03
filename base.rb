module Base
  INPUT_URL = 'https://adventofcode.com/2022/day/:day/input'

  private

  def input
    if File.exist?(input_local_file_for_day)
      File.read(input_local_file_for_day)
    else
      response = Typhoeus.get(
        input_for_day,
        headers: {
          'cookie' => File.read('cookie.txt').strip
        }
      ).body
      File.write(input_local_file_for_day, response)
      response
    end
  end

  def input_for_day
    INPUT_URL.sub(':day', day)
  end

  def input_local_file_for_day
    "day#{day}.txt"
  end

  def day
    self.class.name.downcase.delete('day')
  end
end
