require 'csv'
require 'sidekiq'
require 'sinatra'
require 'sinatra/json'
require_relative 'helpers/endpoint_helper'
require_relative 'helpers/import_csv_helper'
require_relative 'jobs/import_from_csv_job'

set :bind, '0.0.0.0'
set :root, File.dirname(__FILE__)
set :environment, :development

get '/' do
  content_type 'text/html'
  File.open('public/index.html')
end

get '/tests' do
  content_type 'application/json'
  conn = connect_to_database(Sinatra::Application.environment)
  return json [200, 'Nenhum dado foi importado ainda'] unless table_exists?(conn, 'exams')

  json get_exams_list(conn)
end

get '/tests/:tokens' do
  content_type 'application/json'
  conn = connect_to_database(Sinatra::Application.environment)
  return json [200, 'Nenhum dado foi importado ainda'] unless table_exists?(conn, 'exams')

  json get_exams_by_tokens(conn, params)
end

post '/import' do
  uploaded_file = store_data(params[:file][:tempfile])
  ImportFromCSVJob.perform_async(uploaded_file)
  return [200, 'Seu arquivo está sendo processado.']
end
