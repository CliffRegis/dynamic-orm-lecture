class Tweet < InteractiveRecord

  attr_accessor :message, :username
  attr_reader :id

  def initialize(options={})
    @message = options['message']
    @username = options['username']
    @id = options['id']
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM tweets;
    SQL

    results = DB[:conn].execute(sql)
    self.new_from_rows(results)
  end

  def self.find(id)
    # what's the SQL statment that I need to fire
    sql = <<-SQL
    SELECT * FROM tweets
    WHERE id = ?;
    SQL
    # fire the SQL statement
    results = DB[:conn].execute(sql, id)
    # create a new instance of my tweet based on the result
    if results.empty?
      raise 'No Tweet Found'
    else
      self.new(results.first)
    end
  end

  def self.new_from_rows(rows)
    rows.collect do |result|
      Tweet.new(result)
    end
  end

  def save
    # make a call to the database to create a row with a message and a username value
    if self.id
      update
    else
      sql = <<-SQL
      INSERT INTO tweets (username, message)
      VALUES (?, ?);
      SQL
      DB[:conn].execute(sql,username, message)
      # find the row that was just inserted and set the id from that row to this tweets id
      sql = <<-SQL
      SELECT id FROM tweets
      ORDER BY id DESC
      LIMIT 1;
      SQL
      results = DB[:conn].execute(sql)
      self.id = results.first['id']
    end
    self
  end

  def update
    sql = <<-SQL
    UPDATE tweets
    SET username=?, message = ?
    WHERE id = ?;
    SQL

    DB[:conn].execute(sql, username, message, id )
  end

end
