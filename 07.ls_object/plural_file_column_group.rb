# frozen_string_literal: true

require_relative 'file_item'

class PluralFileColumnGroup
  attr_reader :text

  def initialize(filenames, longest_filename_length)
    files = create_file_items(filenames)
    @text = create_text(files, longest_filename_length)
  end

  private

  def create_file_items(filenames)
    filenames.map { |filename| FileItem.new(filename) }
  end

  def create_text(files, longest_filename_length)
    files.map { |file| file.name&.ljust(longest_filename_length + 1) }.join
  end
end
