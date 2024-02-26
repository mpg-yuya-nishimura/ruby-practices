# frozen_string_literal: true

require 'optparse'

class FilesStatsAnalyzer
  def initialize
    extract_options
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
end
