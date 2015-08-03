require 'sqlite3'
require 'singleton'
class Database
  include Singleton

  def initialize
    @databaseConfig=DroidConfig.instance['database']
    @db = SQLite3::Database.open @databaseConfig['database']
  end

  def initializeTables
    @db.execute "CREATE TABLE IF NOT EXISTS modmail (Id INTEGER PRIMARY KEY,thingid TEXT)"
  end


  def addmodmail(id)
    @db.execute "INSERT INTO modmail(thingid) VALUES ('#{id}')"
  end

  def seenbefore?(id)
    stm = @db.prepare "SELECT count(*) FROM modmail WHERE thingid=?"
    stm.bind_param 1,id
    rs = stm.execute
    rs.next[0]==1
  end
end