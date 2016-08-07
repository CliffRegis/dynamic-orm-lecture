require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def self.table_name
    "#{self.to_s.downcase}s"
  end

  def self.column_names
    DB[:conn].results_as_hash = true

    sql = "pragma table_info('#{table_name}')"

    table_info = DB[:conn].execute(sql)
    column_names = []
    table_info.each do |row|
      column_names << row["name"]
    end
    column_names.compact
  end

  def initialize(options={})
    options.each do |property, value|
      self.send("#{property}=", value)
    end
  end

  def save
    sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  end

  def table_name_for_insert
    self.class.table_name
  end

  def values_for_insert
    values = []
    self.class.column_names.each do |col_name|
      values << "'#{send(col_name)}'" unless send(col_name).nil?
    end
    values.join(", ")
  end

  def col_names_for_insert
    self.class.column_names.delete_if {|col| col == "id"}.join(", ")
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM #{self.table_name} WHERE name = '#{name}'"
  end


  def self.all
    sql = "SELECT * FROM #{self.table_name}"
    DB[:conn].execute(sql)
    all_rows = DB[:conn].execute(sql)
    all_rows.map do |row_info|
      column_name_keys = row_info.keys && eval("#{self.table_name.singularize.capitalize}.column_names")
      row_info.delete_if {|k, v| !column_names.include?(k)}
      eval("#{self.table_name.singularize.capitalize}.new(#{row_info})")
    end
  end

  def self.find(id)
    sql = "SELECT * FROM #{table_name} WHERE id = ?"
    student_row = DB[:conn].execute(sql, id)
    column_name_keys = student_row.keys && eval("#{self.table_name.singularize.capitalize}.column_names")
    student_row.delete_if {|k, v| !column_names.include?(k)}
    eval("#{table_name.singularize.capitalize}.new(#{student_row}")
  end

  def self.find_by(attribute_hash)
    value = attribute_hash.values.first
    formatted_value = value.class == Fixnum ? value : "'#{value}'"
    sql = "SELECT * FROM #{self.table_name} WHERE #{attribute_hash.keys.first} = #{formatted_value}"
    DB[:conn].execute(sql)
  end

  def self.foreign_key_tables
    sql = "pragma foreign_key_list('#{table_name}')"
    list_of_table_info = DB[:conn].execute(sql)
    list_of_table_info.collect do |table_info_hash| 
      table_info_hash["table"]
    end
  end
end