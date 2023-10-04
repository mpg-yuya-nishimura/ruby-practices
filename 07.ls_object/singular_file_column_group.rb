# frozen_string_literal: true

require_relative 'file_item'
require_relative 'file_column_group'

class SingularFileColumnGroup < FileColumnGroup
  def initialize(filename)
    file = create_file_item(filename)
    super(file)
  end

  private

  def create_file_item(filename)
    FileItem.new(filename)
  end

  def create_text(file, _)
    "#{file.type}#{file.permissions} #{file.hard_link} #{file.owner}  #{file.group}  #{file.size} #{file.last_modified_time} #{file.name}"
  end
end
