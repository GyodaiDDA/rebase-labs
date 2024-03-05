require 'sinatra'
require 'pg'

configure :development do
  set :database, {
    adapter: 'postgresql',
    database: 'rebase_app',
    host: 'localhost'
  }
end

configure :test do
  set :database, {
    adapter: 'postgresql',
    database: 'rebase_app_test',
    host: 'localhost'
  }
end
