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

# binding.break

filename = ARGV[0]

unless filename && File.exist?(filename)
  puts '指定のファイルは存在しません'
  exit
end

line_count = 0
word_count = 0
byte_count = 0

File.open(filename, "r") do |file|
  file.each_line do |line|
    line_count += 1
    word_count += word_count.split(/\s+/).size
    byte_count += line.bytesize
  end
end
