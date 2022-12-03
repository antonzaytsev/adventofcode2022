module Base
  private

  def input
    if File.exist?(@input_local_file)
      File.read(@input_local_file)
    else
      response = Typhoeus.get(
      @input,
        headers: {
          'cookie' => nil
        }
      ).body
      File.write(@input_local_file, response)
      response
    end
  end
end
