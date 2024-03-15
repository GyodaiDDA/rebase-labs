require 'sidekiq'
require_relative '../helpers/import_csv_helper'
require_relative 'clean_data_storage_job'

class ImportFromCSVJob
  include Sidekiq::Worker

  def perform(uploaded_file)
    file = File.open(uploaded_file)
    FileImport.new(file, Sinatra::Application.environment)
    CleanDataStorageJob.perform_async(uploaded_file)
  end
end
