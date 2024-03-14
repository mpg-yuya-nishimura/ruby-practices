# frozen_string_literal: true

class WcFile
  attr_reader :result_text

  def initialize(options, file_result_stat)
    @options = options
    @line_count = file_result_stat[:line_count]
    @word_count = file_result_stat[:word_count]
    @byte_count = file_result_stat[:byte_count]
    @name = file_result_stat[:name]
    @result_text = create_column_text
  end
end
