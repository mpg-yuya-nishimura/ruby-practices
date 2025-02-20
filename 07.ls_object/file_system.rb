# frozen_string_literal: true

require 'optparse'
require_relative 'singular_file_column_group'
require_relative 'plural_file_column_group'

SEGMENT_LENGTH = 3

class FileSystem
  def initialize(argv)
    extract_options(argv)
    @filenames = fetch_filenames
    @total_blocks = @filenames.sum { |filename| File.stat(filename).blocks }
    @file_column_groups = create_file_column_groups
  end

  def display
    puts "total #{@total_blocks}" if @options[:l]
    @file_column_groups.each do |column_file_group|
      puts column_file_group.text
    end
  end

  private

  def create_file_column_groups
    if @options[:l]
      @filenames.map { |filename| SingularFileColumnGroup.new(filename) }
    else
      longest_filename_length = divide_into_segments.flatten.max_by(&:length).length
      transpose(divide_into_segments).map { |transposed_filename| PluralFileColumnGroup.new(transposed_filename, longest_filename_length) }
    end
  end

  def extract_options(argv)
    opt = OptionParser.new
    @options = {}
    opt.on('-a') { |v| @options[:a] = v }
    opt.on('-r') { |v| @options[:r] = v }
    opt.on('-l') { |v| @options[:l] = v }
    opt.parse!(argv)
  end

  def fetch_filenames
    filenames = Dir.glob('*')
    filenames = Dir.entries('.').sort if @options[:a]
    filenames.reverse! if @options[:r]
    filenames
  end

  def divide_into_segments
    @filenames.each_slice((@filenames.length + 2) / SEGMENT_LENGTH).to_a
  end

  def transpose(filenames)
    max_size = filenames.map(&:size).max
    filenames.map! { |items| items.values_at(0...max_size) }
    filenames.transpose
  end

  def sample_method
    puts "rgrrg"
  end
end
