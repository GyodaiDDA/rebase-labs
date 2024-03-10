require 'pg'
require 'yaml'
require 'dotenv'

def connect_to_database(environment)
  PG.connect(host: environment.to_s,
             dbname: environment.to_s,
             user: 'user', 
             password: 'password')
rescue PG::Error => e
  puts "Erro de conexão ao banco de dados: #{e.message}"
end

def reset_database(environment)
  conn = PG.connect(host: environment.to_s,
                    dbname: 'postgres',
                    user: 'user', 
                    password: 'password')
  break_db_connections(conn, environment)
  conn.exec("DROP DATABASE IF EXISTS #{environment}") 
  conn.exec("CREATE DATABASE #{environment}")
  conn.close
end

def break_db_connections(conn, environment)
  conn.exec("BEGIN") 
  conn.exec("SAVEPOINT sp1")
  conn.exec("SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '#{environment}'")
  conn.exec("ROLLBACK TO sp1")
  conn.exec("COMMIT")
end

def table_exists?(conn, table_name)
  return unless conn

  result = conn.exec_params('SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = $1)', [table_name])
  exists = result[0]['exists']
  exists == 't'
end

def create_tables(conn)
  conn.exec(File.open('helpers/create_tables.sql').read)
end
