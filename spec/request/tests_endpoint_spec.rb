require 'spec_helper'
require 'sinatra'
require_relative '../../app'

RSpec.describe 'test_endpoint_response', type: :request do
  def app
    Sinatra::Application
  end

  it 'should return data in json format' do
    get '/tests'
    expect(last_response.status).to eq 200
    expect(last_response.content_type).to eq 'application/json'
    expect(last_response.body).to include 'coluna_1'
    expect(last_response.body).to include 'coluna_2'
    expect(last_response.body).to include 'coluna_3'
    expect(last_response.body).to include 'Dado 11'
    expect(last_response.body).to include 'Dado 35'
    expect(last_response.body).to include 'Dado 46'
  end
end
