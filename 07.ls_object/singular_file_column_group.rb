# frozen_string_literal: true

require_relative 'file_item'

class SingularFileColumnGroup
  attr_reader :text

  def initialize(filename)
    file = create_file_item(filename)
    @text = file.create_text
  end

  private

  def create_file_item(filename)
    FileItem.new(filename)
  end
end
