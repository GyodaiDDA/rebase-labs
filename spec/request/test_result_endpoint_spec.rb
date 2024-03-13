require 'spec_helper'
require 'sinatra'
require 'rspec'
require 'rack/test'
require_relative '../../server'

RSpec.describe '/tests/:token' do
  include Rack::Test::Methods
  Sinatra::Application.environment = :test
  
  def app
    Sinatra::Application
  end

  context 'the database is empty' do
    it 'should return 200 with message ' do
      reset_database(:test)

      get '/tests/ICQ123'
      
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to include 'Nenhum dado foi importado ainda'
      expect(last_response.body).not_to include('hemácias')
      expect(last_response.body).not_to include('ICQ123')
      expect(last_response.body).not_to include('carlatnt@internet.ops')
    end
  end
  
  context 'the token is not found' do
    it 'should return 404' do
      reset_database(:test)
      system 'ruby import_from_csv.rb test'

      get '/tests/ICQ124'

      expect(last_response.status).to eq 404
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to include 'Token não encontrado'
    end
  end

  context 'one token is found' do
    it "should return only that token's data" do
      reset_database(:test)
      system 'ruby import_from_csv.rb test'
      
      get '/tests/ICQ123'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to include('hemácias')
      expect(last_response.body).to include('ICQ123')
      expect(last_response.body).to include('carlatnt@internet.ops')
      expect(last_response.body).to include('04888317088')
      expect(last_response.body).not_to include('tgp')
      expect(last_response.body).not_to include('21212811104')
      expect(last_response.body).not_to include('maumau_245@parapi.tk')
    end
  end

  context 'more than one token is found' do
    it "should return only the found tokens' data" do
      reset_database(:test)
      system 'ruby import_from_csv.rb test'
      
      get '/tests/ICQ123,4WDI67,58SD45'

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
      expect(last_response.body).not_to include('tgp')
      expect(last_response.body).not_to include('21212811104')
      expect(last_response.body).not_to include('maumau_245@parapi.tk')
    end
  end
end
