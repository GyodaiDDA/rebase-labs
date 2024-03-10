require 'spec_helper'
require 'sinatra'
require 'rspec'
require 'rack/test'
require_relative '../../app'

RSpec.describe 'Exam Results Endpoint' do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application.environment = :test
    Sinatra::Application
  end

  before(:each) do
    reset_database(:test)
  end

  after(:each) do
    reset_database(:test)
  end
  
  context 'has no entries in the database' do
    it 'should return message' do

      reset_database(:test)
      get '/tests'
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to include 'Nenhum dado foi importado ainda'
    end
  end

  context 'has entries in the database' do
    it 'should return data' do
      reset_database(:test)
      system 'ruby import_from_csv.rb test'
      get '/tests'
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to include('04888317088')
      expect(last_response.body).to include('4WDI67')
      expect(last_response.body).to include('hemácias')
      expect(last_response.body).to include('java@lina.pir')
      expect(last_response.body).not_to include 'Nenhum dado foi importado ainda'
    end
  end
end
