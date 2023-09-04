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

if ARGV.empty?
  puts 'ファイルの指定がありません。'
end

unless file_exist?(ARGV)
  puts '指定のファイルは存在しません'
end

integrated_count_results = ARGV.map do |filename|
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

integrated_count_results.each do |integrated_count_result|
  count_result_text = ''
  count_result_text += integrated_count_result[0].to_s.rjust(8) if options[:l] || options.empty?
  count_result_text += integrated_count_result[1].to_s.rjust(8) if options[:w] || options.empty?
  count_result_text += integrated_count_result[2].to_s.rjust(8) if options[:c] || options.empty?

  puts "#{count_result_text} #{integrated_count_result[3]}"
end
