
require 'bundler'
Bundler.require


DB = {:conn => SQLite3::Database.new("db/twitter.db")}
DB[:conn].execute("DROP TABLE IF EXISTS tweets")
DB[:conn].execute("DROP TABLE IF EXISTS users")


sql = <<-SQL
  CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY, 
  username TEXT, 
  email TEXT
  )
SQL

DB[:conn].execute(sql)

sql = <<-SQL
  CREATE TABLE IF NOT EXISTS tweets (
  id INTEGER PRIMARY KEY, 
  message TEXT, 
  user_id INTEGER REFERENCES user(userid)
  )
SQL

   


DB[:conn].execute(sql)
DB[:conn].results_as_hash = true

require_relative "../lib/interactive_record.rb"
require_relative "../lib/tweet.rb"
require_relative "../lib/user.rb"