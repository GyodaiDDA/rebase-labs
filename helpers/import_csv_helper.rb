require 'pg'
require 'csv'
require_relative 'database_helper'

class FileImport
  def initialize(csv_file, environment)
    csv_table = CSV.table(csv_file)
    send_to_database(csv_table, environment)
  end

  def send_to_database(csv_table, environment)
    conn = connect_to_database(environment)
    create_table(conn, csv_table)
    populate_table(conn, csv_table)
    conn.close
    puts 'Dados importados com sucesso.'
  end

  def create_table(conn, csv_table)
    create_table = <<~SQL
      CREATE TABLE IF NOT EXISTS imported (id SERIAL PRIMARY KEY,
      #{csv_table.headers.join(" VARCHAR(50),\n")} VARCHAR(50));
    SQL
    conn.exec(create_table)
  end

  def populate_table(conn, csv_table)
    headers = csv_table.headers.join(', ')
    csv_table.each do |row|
      conn.exec(
        "INSERT INTO imported (#{headers}) VALUES ('#{row.fields.join("', '")}')"
      )
    end
  end

  def table_exists?(conn, table_name)
    result = conn.exec_params('SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = $1)',
                              [table_name])
    exists = result[0]['exists']
    exists == 't'
  end
end
