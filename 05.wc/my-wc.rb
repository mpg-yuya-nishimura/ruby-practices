#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'

require 'debug'

def file_exist?(filenames)
  filenames.all? { |filename| File.exist?(filename) }
end

opt = OptionParser.new
options = {}
opt.on('-l') { |v| options[:l] = v }
opt.on('-w') { |v| options[:w] = v }
opt.on('-c') { |v| options[:c] = v }
opt.parse!(ARGV)

if ARGV.empty? && $stdin.tty?
  puts 'ファイルの指定がありません。'
  exit
end

unless file_exist?(ARGV)
  puts '指定のファイルは存在しません'
  exit
end

filenames = ARGV.empty? ? $stdin.read.split(/\n+/) : ARGV

integrated_count_results = filenames.map do |filename|
  line_count = 0
  word_count = 0
  byte_count = 0

  file = File.open(filename, "r")

  file.each_line do |line|
    line_count += 1
    word_count += line.split(/\s+/).size
    byte_count += line.bytesize
  end

  [line_count, word_count, byte_count, filename]
end

total_stats = [0, 0, 0]

integrated_count_results.each do |integrated_count_result|
  count_result_text = ''
  count_result_text += integrated_count_result[0].to_s.rjust(8) if options[:l] || options.empty?
  count_result_text += integrated_count_result[1].to_s.rjust(8) if options[:w] || options.empty?
  count_result_text += integrated_count_result[2].to_s.rjust(8) if options[:c] || options.empty?

  total_stats[0] += integrated_count_result[0]
  total_stats[1] += integrated_count_result[1]
  total_stats[2] += integrated_count_result[2]

  puts "#{count_result_text} #{integrated_count_result[3]}"
end

if filenames.size > 1
  total_stats_text = ''
  total_stats_text += total_stats[0].to_s.rjust(8) if options[:l] || options.empty?
  total_stats_text += total_stats[1].to_s.rjust(8) if options[:w] || options.empty?
  total_stats_text += total_stats[2].to_s.rjust(8) if options[:c] || options.empty?

  puts "#{total_stats_text} total"
end
