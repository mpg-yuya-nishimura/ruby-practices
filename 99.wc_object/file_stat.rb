# frozen_string_literal: true

require 'optparse'
require_relative './wc'

class FileStat
  def initialize(argv)
    @options, @filenames = extract_options(argv)
  end

  def display
    fetch_wc_files.each do |wc_file|
      text = ''
      text += wc_file.line_count.to_s.rjust(8) if @options[:l] || @options.empty?
      text += wc_file.word_count.to_s.rjust(8) if @options[:w] || @options.empty?
      text += wc_file.byte_count.to_s.rjust(8) if @options[:c] || @options.empty?
      puts "#{text} #{wc_file.name}"
    end
  end

  private

  def extract_options(argv)
    options = {}
    opt = OptionParser.new
    opt.on('-l') { |v| options[:l] = v }
    opt.on('-w') { |v| options[:w] = v }
    opt.on('-c') { |v| options[:c] = v }
    filenames = opt.parse(argv)

    [options, filenames]
  end

  def fetch_wc_files
    if @filenames.empty?
      [Wc.new(text: $stdin.read)]
    else
      files = @filenames.map { |filename| File.open(filename) }
      wc_files = build_wc_files(files)
      wc_files << build_total_wc_file(wc_files) if files.size > 1
      wc_files
    end
  end

  def build_wc_files(files)
    files.map { |file| Wc.new(text: file.read, filename: file.path) }
  end

  def build_total_wc_file(wc_files)
    total_wc_file_class = Data.define(:line_count, :word_count, :byte_count, :name)
    total_wc_file_class.new(
      line_count: wc_files.sum(&:line_count),
      word_count: wc_files.sum(&:word_count),
      byte_count: wc_files.sum(&:byte_count),
      name: 'total'
    )
  end
end
