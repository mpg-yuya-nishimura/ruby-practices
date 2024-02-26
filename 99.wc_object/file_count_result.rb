# frozen_string_literal: true

class FileCountResult
  attr_reader :text

  def initialize(file, options)
    @file_name = file[:name] || 'total'
    @line_count = file[:line_count].to_s
    @word_count = file[:word_count].to_s
    @byte_count = file[:byte_count].to_s
    @text = create_result_text(options)
  end

  private

  def create_result_text(options)
    text = ''
    text += @line_count.rjust(8) if options[:l] || options.empty?
    text += @word_count.rjust(8) if options[:w] || options.empty?
    text += @byte_count.rjust(8) if options[:c] || options.empty?
    "#{text} #{@file_name}"
  end
end
