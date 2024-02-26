# frozen_string_literal: true

require 'optparse'

class FileStatsAnalyzer
  def initialize
    extract_options
    @original_argv = ARGV.dup
    validate_files_accessible
  end

  def display
  end

  private

  def extract_options
    opt = OptionParser.new
    @options = {}
    opt.on('-a') { |v| @options[:a] = v }
    opt.on('-r') { |v| @options[:r] = v }
    opt.on('-l') { |v| @options[:l] = v }
    opt.parse!(ARGV)
  end

  def validate_files_accessible
    unless ARGF
      puts '指定のファイルは存在しません'
      exit
    end

    unless all_files_exist?
      puts '指定のファイルは存在しません'
      exit
    end
  end

  def all_files_exist?
    @original_argv.all? { |filename| File.exist?(filename) }
  end
end
