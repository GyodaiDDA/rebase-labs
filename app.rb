require 'csv'
require 'sinatra'
require 'sinatra/json'
require_relative 'helpers/import_csv_helper'
require_relative 'helpers/database_helper'

set :environment, :development

set :bind, '0.0.0.0'

get '/tests' do
  conn = connect_to_database('development')
  return json [200, 'Nenhum dado foi importado ainda'] unless table_exists?(conn, 'imported')

  data = []
  result = conn.exec('SELECT * FROM imported;')
  result.each { |row| data << row }
  json data
end
