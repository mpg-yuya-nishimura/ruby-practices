#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def file_exist?(filenames)
  filenames.all? { |filename| File.exist?(filename) }
end

def create_result_text(stat, options)
  text = ''
  text += stat[:line_count].to_s.rjust(8) if options[:l] || options.empty?
  text += stat[:word_count].to_s.rjust(8) if options[:w] || options.empty?
  text += stat[:byte_count].to_s.rjust(8) if options[:c] || options.empty?
  text
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

file_metadata = { line_count: 0, word_count: 0, byte_count: 0, name: '' }
total_stats = { line_count: 0, word_count: 0, byte_count: 0 }
file_stats = []

ARGF.each do |line|
  file_metadata[:line_count] += 1
  file_metadata[:word_count] += line.split.size
  file_metadata[:byte_count] += line.bytesize

  total_stats[:line_count] += 1
  total_stats[:word_count] += line.split.size
  total_stats[:byte_count] += line.bytesize

  next unless ARGF.eof?

  file_metadata[:name] = ARGF.filename if original_argv.size.positive?
  file_stats << file_metadata
  file_metadata = { line_count: 0, word_count: 0, byte_count: 0, name: '' }

  ARGF.close

  break if ARGF.argv.empty?
end

file_stats.each do |file_stat|
  puts "#{create_result_text(file_stat, options)} #{file_stat[:name]}"
end

puts "#{create_result_text(total_stats, options)} total" if original_argv.size > 1
