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

  private

  def create_column_text
    text = ''
    text += @line_count.to_s.rjust(8) if @options[:l] || @options.empty?
    text += @word_count.to_s.rjust(8) if @options[:w] || @options.empty?
    text += @byte_count.to_s.rjust(8) if @options[:c] || @options.empty?
    file_name = @name || 'total'
    "#{text} #{file_name}"
  end
end
