require 'csv'
require 'sinatra'
require 'sinatra/json'
require_relative 'helpers/import_csv_helper'
require_relative 'helpers/database_helper'

set :bind, '0.0.0.0'
set :root, File.dirname(__FILE__)
set :environment, :development

get '/tests' do
  content_type 'application/json'
  conn = connect_to_database(Sinatra::Application.environment)
  return json [200, 'Nenhum dado foi importado ainda'] unless table_exists?(conn, 'exams')

  result = conn.exec(File.open('helpers/query.sql').read)
  data = result.to_a
  data.each do |row|
    row['doctor'] = JSON.parse(row['doctor']) if row['doctor']
    row['tests'] = JSON.parse(row['tests']) if row['tests']
  end
  json data
end

get '/' do
  content_type 'text/html'
  File.open('public/index.html')
end