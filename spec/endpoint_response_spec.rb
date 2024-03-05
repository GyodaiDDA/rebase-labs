require_relative '../app'
require 'test/unit'
require 'rack/test'

class APITest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_endpoint_response
    get '/tests'
    assert last_response.ok?
    assert last_response.content_type == 'application/json'
    assert last_response.body.include? 'coluna_1'
    assert last_response.body.include? 'coluna_2'
    assert last_response.body.include? 'coluna_3'
    assert last_response.body.include? 'Dado 11'
    assert last_response.body.include? 'Dado 35'
    assert last_response.body.include? 'Dado 46'
  end

  def test_file_import; end
end
