# frozen_string_literal: true

require 'optparse'
require_relative 'wc_file'

class Wc
  def initialize(argv)
    @argv = argv
    @options = {}
    extract_options
    @filenames = @argv.dup
  end

  def display
    unless all_files_exist?
      puts '指定のファイルは存在しません'
      return
    end

    create_result_texts.each do |file_stat_text|
      puts file_stat_text
    end
  end

  private

  def extract_options
    opt = OptionParser.new
    opt.on('-l') { |v| @options[:l] = v }
    opt.on('-w') { |v| @options[:w] = v }
    opt.on('-c') { |v| @options[:c] = v }
    opt.parse!(@argv)
  end

  def all_files_exist?
    @filenames.all? { |filename| File.exist?(filename) }
  end

  def create_result_texts
    calc_file_stats.map do |file_stat|
      text = ''
      text += file_stat.line_count.to_s.rjust(8) if @options[:l] || @options.empty?
      text += file_stat.word_count.to_s.rjust(8) if @options[:w] || @options.empty?
      text += file_stat.byte_count.to_s.rjust(8) if @options[:c] || @options.empty?
      "#{text} #{file_stat.name}"
    end
  end

  def calc_file_stats
    stats = if @argv.empty?
              [WcFile.new(text: $stdin.read)]
            else
              files = @argv.map { |filename| File.open(filename) }
              files.map { |file| WcFile.new(text: file.read, filename: file.path) }
            end
    stats << calc_total_stats(files) if @filenames.size > 1
    stats
  end

  def calc_total_stats(files)
    linked_text = files.map do |file|
      file.rewind
      file.read
    end.join

    WcFile.new(text: linked_text, filename: 'total')
  end
end
