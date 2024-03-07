#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'file_stats_analyzer'

file_stats_analyzer = FileStatsAnalyzer.new(ARGV, ARGF)
file_stats_analyzer.display
