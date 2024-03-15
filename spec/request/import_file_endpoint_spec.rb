require 'csv'
require 'spec_helper'
require 'sinatra'
require 'rspec'
require 'rack/test'
require 'sidekiq'
require_relative '../../jobs/import_from_csv_job'
require_relative '../../server'

RSpec.describe('/import') do
  include Rack::Test::Methods
  Sinatra::Application.environment = :development

  def app
    Sinatra::Application
  end

  context 'receives post request with params' do
    it 'and runs import job' do
      file_path = 'csv/test_file.csv'
      spy = spy('ImportFromCSVJob')
      stub_const('ImportFromCSVJob', spy)

      post '/import', file: Rack::Test::UploadedFile.new(file_path, 'text/csv')

      expect(ImportFromCSVJob).to have_received(:perform_async)
    end
  end
end
