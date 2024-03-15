require 'sidekiq'
require_relative '../helpers/import_csv_helper'

class CleanDataStorageJob
  include Sidekiq::Worker

  def perform(filename)
    File.exist?(filename) ? File.delete(filename) : return
  end
end
