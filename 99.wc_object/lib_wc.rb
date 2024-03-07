# frozen_string_literal: true

require 'optparse'

class Wc
  def initialize(argv, argf)
    @argv = argv
    @argf = argf
    @options = {}
    extract_options
    @filenames = @argv.dup
  end

  def display
    unless all_files_exist?
      puts '指定のファイルは存在しません'
      return
    end

    calc_file_stats_results.each do |file|
      puts file
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

  def calc_file_stats_results
    file_metadata = { line_count: 0, word_count: 0, byte_count: 0, name: '' }
    total_stats = { line_count: 0, word_count: 0, byte_count: 0 }
    file_result_stats = []

    @argf.each do |line|
      file_metadata[:line_count] += 1
      file_metadata[:word_count] += line.split.size
      file_metadata[:byte_count] += line.bytesize

      total_stats[:line_count] += 1
      total_stats[:word_count] += line.split.size
      total_stats[:byte_count] += line.bytesize

      next unless @argf.eof?

      file_metadata[:name] = @argf.filename if @filenames.size.positive?
      file_result_stats << file_metadata
      file_metadata = { line_count: 0, word_count: 0, byte_count: 0, name: '' }

      @argf.close

      break if @argf.argv.empty?
    end

    file_result_stats << total_stats if @filenames.size > 1
    file_result_stats = file_result_stats.map { |file_result_stat| create_column_text(file_result_stat) }
  end

  def create_column_text(file)
    text = ''
    text += file[:line_count].to_s.rjust(8) if @options[:l] || @options.empty?
    text += file[:word_count].to_s.rjust(8) if @options[:w] || @options.empty?
    text += file[:byte_count].to_s.rjust(8) if @options[:c] || @options.empty?
    file_name = file[:name] || 'total'
    "#{text} #{file_name}"
  end
end
