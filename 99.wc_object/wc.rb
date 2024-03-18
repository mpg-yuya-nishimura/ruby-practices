# frozen_string_literal: true

require 'optparse'
require_relative 'wc_file'

class Wc
  def initialize(argv)
    @options, @filenames = extract_options(argv)
  end

  def display
    puts create_result_texts
  end

  private

  def extract_options(argv)
    options = {}
    opt = OptionParser.new
    opt.on('-l') { |v| options[:l] = v }
    opt.on('-w') { |v| options[:w] = v }
    opt.on('-c') { |v| options[:c] = v }
    filenames = opt.parse!(argv)

    [options, filenames]
  end

  def create_result_texts
    determine_input_files.map do |file_stat|
      text = ''
      text += file_stat.line_count.to_s.rjust(8) if @options[:l] || @options.empty?
      text += file_stat.word_count.to_s.rjust(8) if @options[:w] || @options.empty?
      text += file_stat.byte_count.to_s.rjust(8) if @options[:c] || @options.empty?
      "#{text} #{file_stat.name}"
    end
  end

  def determine_input_files
    if @filenames.empty?
      [WcFile.new(text: $stdin.read)]
    else
      files = @filenames.map { |filename| File.open(filename) }
      wc_files = build_wc_files(files)
      wc_files << build_total_wc_file(files) if files.size > 1
      wc_files
    end
  end

  def build_wc_files(files)
    files.map { |file| WcFile.new(text: file.read, filename: file.path) }
  end

  def build_total_wc_file(files)
    linked_text = files.map do |file|
      file.rewind
      file.read
    end.join

    WcFile.new(text: linked_text, filename: 'total')
  end
end
