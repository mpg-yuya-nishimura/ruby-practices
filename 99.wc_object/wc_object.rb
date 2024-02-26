#!/usr/bin/env ruby

# frozen_string_literal: true

require 'debug'

require_relative 'file_stats_analyzer'

file_stats_analyzer = FileStatsAnalyzer.new
file_stats_analyzer.display
