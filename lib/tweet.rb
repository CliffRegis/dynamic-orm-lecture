class Tweet < InteractiveRecord

  self.column_names.each do |col_name|
    attr_accessor col_name.to_sym
  end

  self.foreign_key_tables.each do |table_name|
    define_method table_name do
      fk_id = self.send("#{table_name}_id")
      user_row = DB[:conn].execute("SELECT * FROM #{table_name.pluralize} WHERE id = #{fk_id}").first
      user_row.delete_if {|k, v| !(eval("#{table_name.capitalize}.column_names.include?(k)"))}
      eval("#{table_name.capitalize}.new(#{user_row})")
    end

    define_method "#{table_name}=" do
      self.send("#{table_name}_id=", instance.id)
      self.save
    end
  end

  # def user
  #   DB[:conn].execute("SELECT * FROM users WHERE id = #{self.user_id}")
  # end

  # def user=(user)
  #   DB[:conn].execute("INSERT INTO users VALUES ?, ?", user.username, user.email)
  # end

  # def self.all
  #   sql = <<-SQL
  #   SELECT * FROM tweets;
  #   SQL

  #   results = DB[:conn].execute(sql)
  #   self.new_from_rows(results)
  # end

  # def self.find(id)
  #   # what's the SQL statment that I need to fire
  #   sql = <<-SQL
  #   SELECT * FROM tweets
  #   WHERE id = ?;
  #   SQL
  #   # fire the SQL statement
  #   results = DB[:conn].execute(sql, id)
  #   # create a new instance of my tweet based on the result
  #   if results.empty?
  #     raise 'No Tweet Found'
  #   else
  #     self.new(results.first)
  #   end
  # end

  # def self.new_from_rows(rows)
  #   rows.collect do |result|
  #     Tweet.new(result)
  #   end
  # end

  # def initialize(options={})
  #   @message = options['message']
  #   @username = options['username']
  #   @id = options['id']
  # end

  # def save
  #   # make a call to the database to create a row with a message and a username value
  #   if self.id
  #     update
  #   else
  #     sql = <<-SQL
  #     INSERT INTO tweets (username, message)
  #     VALUES (?, ?);
  #     SQL
  #     DB[:conn].execute(sql,username, message)
  #     # find the row that was just inserted and set the id from that row to this tweets id
  #     sql = <<-SQL
  #     SELECT id FROM tweets
  #     ORDER BY id DESC
  #     LIMIT 1;
  #     SQL
  #     results = DB[:conn].execute(sql)
  #     self.id = results.first['id']
  #   end
  #   self
  # end

  # def update
  #   sql = <<-SQL
  #   UPDATE tweets
  #   SET username=?, message = ?
  #   WHERE id = ?;
  #   SQL

  #   DB[:conn].execute(sql, username, message, id )
  # end

end
