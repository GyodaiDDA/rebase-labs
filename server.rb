require 'csv'
require 'sinatra'
require 'sinatra/json'
require_relative 'helpers/endpoint_helper'


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