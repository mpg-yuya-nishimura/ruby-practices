# frozen_string_literal: true

class FileCountResult
  attr_reader :text

  def initialize(file, options)
    @text = create_result_text(file, options)
  end

  private

  def create_result_text(file, options)
    text = ''
    text += file[:line_count].to_s.rjust(8) if options[:l] || options.empty?
    text += file[:word_count].to_s.rjust(8) if options[:w] || options.empty?
    text += file[:byte_count].to_s.rjust(8) if options[:c] || options.empty?
    file_name = file[:name] || 'total'
    "#{text} #{file_name}"
  end
end
