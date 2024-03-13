require 'spec_helper'
require 'sinatra'
require 'rspec'
require 'rack/test'
require_relative '../../server'

RSpec.describe '/tests' do
  include Rack::Test::Methods
  Sinatra::Application.environment = :test
  
  def app
    Sinatra::Application
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
      expect(last_response.body).to include('hemácias')
      expect(last_response.body).to include('plaquetas')
      expect(last_response.body).to include('ICQ123')
      expect(last_response.body).to include('4WDI67')
      expect(last_response.body).to include('carlatnt@internet.ops')
      expect(last_response.body).to include('julinha_da_van@parapi.tk')
      expect(last_response.body).to include('04888317088')
      expect(last_response.body).to include('24810802604')
      expect(last_response.body).to include('tgp')
      expect(last_response.body).to include('21212811104')
      expect(last_response.body).to include('maumau_245@parapi.tk')
    end
  end
end
