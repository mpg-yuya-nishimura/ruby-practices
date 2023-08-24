#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'

require 'debug'

opt = OptionParser.new
options = {}
opt.on('-l') { |v| options[:l] = v }
opt.on('-w') { |v| options[:w] = v }
opt.on('-c') { |v| options[:c] = v }
opt.parse!(ARGV)

filename = ARGV[0]

unless filename && File.exist?(filename)
  puts '指定のファイルは存在しません'
  exit
end

line_count = 0
word_count = 0
byte_count = 0


file = File.open(filename, "r")

file.each_line do |line|
  line_count += 1
  word_count += line.split(/\s+/).size
  byte_count += line.bytesize
end

count_result_text = ''
count_result_text += line_count.to_s.rjust(8) if options[:l] || options.empty?
count_result_text += word_count.to_s.rjust(8) if options[:w] || options.empty?
count_result_text += byte_count.to_s.rjust(8) if options[:c] || options.empty?

puts count_result_text
