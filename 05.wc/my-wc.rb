#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'

def file_exist?(filenames)
  filenames.all? { |filename| File.exist?(filename) }
end

def create_result_text(stats, options)
  text = ''
  text += stats[0].to_s.rjust(8) if options[:l] || options.empty?
  text += stats[1].to_s.rjust(8) if options[:w] || options.empty?
  text += stats[2].to_s.rjust(8) if options[:c] || options.empty?
end

opt = OptionParser.new
options = {}
opt.on('-l') { |v| options[:l] = v }
opt.on('-w') { |v| options[:w] = v }
opt.on('-c') { |v| options[:c] = v }
opt.parse!(ARGV)

original_argv = ARGV.dup

unless ARGF
  puts '指定のファイルは存在しません'
  exit
end

unless file_exist?(original_argv)
  puts '指定のファイルは存在しません'
  exit
end

file_stats = ARGV.map do |filename|
  line_count = 0
  word_count = 0
  byte_count = 0

  file = File.open(filename, 'r')

  file.each_line do |line|
    line_count += 1
    word_count += line.split.size
    byte_count += line.bytesize
  end

  [line_count, word_count, byte_count, filename]
end

file_stats.each { |file_stat| puts "#{create_result_text(file_stat, options)} #{file_stat[3]}" }

total_stats = [0, 0, 0]
ARGF.each do |line|
  total_stats[0] += 1
  total_stats[1] += line.split.size
  total_stats[2] += line.bytesize
end

puts "#{create_result_text(total_stats, options)} total" unless original_argv.size == 1
