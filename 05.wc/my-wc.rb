require 'optparse'
require 'etc'

opt = OptionParser.new
options = {}
opt.on('-l') { |v| options[:l] = v }
opt.on('-w') { |v| options[:w] = v }
opt.on('-c') { |v| options[:c] = v }
opt.parse!(ARGV)
