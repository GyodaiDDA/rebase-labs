require 'rack/test'
require 'rspec'
require_relative '../../server'

ENV['RACK_ENV'] = 'test'

RSpec.describe '/tests/:token' do
  include Rack::Test::Methods
  Sinatra::Application.environment = :test

  def app
    Sinatra::Application
  end

  it "responds with the content of 'public/index.html'" do
    get '/'

    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('text/html;charset=utf-8')
    expect(last_response.body).to include('<button id="search-button">Search</button>')
    expect(last_response.body).to include('<button id="list-button">See all data</button>')
  end
end
