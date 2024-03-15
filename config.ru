require 'server'
require 'sinatra'
require 'pg'
require 'sidekiq/web'

configure :development do
  set :database, {
    adapter: 'postgresql',
    database: 'development',
    user:,
    password:,
    host: 'development'
  }
end

configure :test do
  set :database, {
    adapter: 'postgresql',
    database: 'test',
    user:,
    password:,
    host: 'test'
  }
end
