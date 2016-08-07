class User < InteractiveRecord

  attr_accessor :username, :email
  attr_reader :id

  def initialize(opts={})
    @username = opts["username"]
    @email = opts["email"]
    @id = opts["id"]
  end

  def save
    # make a call to the database to create a row with a message and a username value
    if self.id
      update
    else
      sql = <<-SQL
      INSERT INTO users (username, email)
      VALUES (?, ?);
      SQL
      DB[:conn].execute(sql,username, email)
      # find the row that was just inserted and set the id from that row to this tweets id
      sql = <<-SQL
      SELECT id FROM users
      ORDER BY id DESC
      LIMIT 1;
      SQL
      results = DB[:conn].execute(sql)
      @id = results.first['id']
    end
    self
  end
end