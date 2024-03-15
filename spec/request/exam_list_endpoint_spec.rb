require 'spec_helper'
require 'sinatra'
require 'rspec'
require 'rack/test'
require_relative '../../server'

RSpec.describe('/tests') do
  include Rack::Test::Methods
  Sinatra::Application.environment = :test

  def app
    Sinatra::Application
  end

  context 'listing all exams' do
    before(:each) do
      reset_database(:test)
    end
    after(:all) do
      reset_database(:test)
    end

    context 'has no entries in the database' do
      it 'should return message' do
        get '/tests'

        expect(last_response.status).to eq 200
        expect(last_response.content_type).to eq 'application/json'
        expect(last_response.body).to include 'Nenhum dado foi importado ainda'
      end
    end

    context 'has entries in the database' do
      it 'should return data' do
        system 'ruby import_from_csv.rb test'

        get '/tests'

        expect(last_response.status).to eq 200
        expect(last_response.content_type).to eq 'application/json'
        response = JSON.parse(last_response.body)
        expect(response['results'].size).to eq 3
        expect(response['results'].first['tests'].first['test']).to eq('hemácias')
        expect(response['results'].last['tests'].first['test']).to eq('tgp')
        expect(response['results'].first['result_token']).to eq('ICQ123')
        expect(response['results'].last['result_token']).to eq('OS9DI0')
        expect(response['results'].first['email']).to eq('carlatnt@internet.ops')
        expect(response['results'].last['email']).to eq('maumau_245@parapi.tk')
        expect(response['results'].first['cpf']).to eq('04888317088')
        expect(response['results'].last['cpf']).to eq('21212811104')
      end
    end
  end
end
