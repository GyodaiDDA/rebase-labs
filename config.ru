require 'app'
require 'sinatra'
require 'pg'

configure :development do
  set :database, {
    adapter: 'postgresql',
    database: 'development',
    user: 'user'
    password: 'password'
    host: 'development'
  }
end

configure :test do
  set :database, {
    adapter: 'postgresql',
    database: 'test',
    user: 'user',
    password: 'password',
    host: 'test'
  }
end
