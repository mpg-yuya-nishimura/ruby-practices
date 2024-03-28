# frozen_string_literal: true

class Wc
  attr_reader :line_count, :word_count, :byte_count, :name

  def initialize(text:, filename: '')
    @line_count = text.split("\n").size
    @word_count = text.split.size
    @byte_count = text.bytesize
    @name = filename
  end
end
