# frozen_string_literal: true

require_relative 'file_item'

class SingularFileColumnGroup
  attr_reader :text

  def initialize(filename)
    file = create_file_item(filename)
    @text = create_text(file)
  end

  private

  def create_file_item(filename)
    FileItem.new(filename)
  end

  def create_text(file)
    "#{file.type}#{file.permissions} #{file.hard_link} #{file.owner}  #{file.group}  #{file.size} #{file.last_modified_time} #{file.name}"
  end
end
