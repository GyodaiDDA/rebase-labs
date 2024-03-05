require 'csv'
require 'sinatra'
require 'sinatra/json'

set :environment, :development

set :bind, '0.0.0.0'

get '/tests' do
  data = CSV.table('example.csv')
  json data
end
