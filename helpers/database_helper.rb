require 'pg'
require 'yaml'

def connect_to_database(environment)
  dbconfig = YAML.load_file('config/database.yml')
  dbsettings = dbconfig[environment.to_s]
  PG.connect(host: dbsettings['host'],
             dbname: dbsettings['database'],
             user: dbsettings['username'],
             password: dbsettings['password'])
rescue PG::Error => e
  puts "Erro de conexão ao banco de dados: #{e.message}"
end

def clean_database(environment)
  conn = connect_to_database(:service)
  dbname = environment.to_s
  conn.exec("DROP DATABASE IF EXISTS #{dbname}")
  conn.exec("CREATE DATABASE #{dbname}")
rescue PG::Error => e
  puts "Erro ao reiniciar o banco de dados: #{e.message}"
ensure
  conn&.close
end

def table_exists?(conn, table_name)
  result = conn.exec_params('SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = $1)', [table_name])
  exists = result[0]['exists']
  exists == 't'
end
