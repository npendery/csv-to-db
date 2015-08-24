require "pg"
require "csv"
require "pry"

def db_connection
  begin
    connection = PG.connect(dbname: "ingredients")
    yield(connection)
  ensure
    connection.close
  end
end


CSV.foreach('ingredients.csv', headers: false) do |add|
  result = nil
  db_connection do |conn|
    result = conn.exec("INSERT INTO ingredients (name) VALUES ('#{add[0]}. #{add[1]}')")
  end
end


ingredient_list = db_connection do |conn|
  conn.exec("SELECT name FROM ingredients")
end

ingredient_list.to_a.each do |ingredient|
  puts ingredient["name"]
end
