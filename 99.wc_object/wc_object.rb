#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'wc'

file_stats_analyzer = Wc.new(ARGV, ARGF)
file_stats_analyzer.display
