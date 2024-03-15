require_relative 'helpers/import_csv_helper'

if ARGV.length.positive?
  FileImport.new(File.open('csv/test_file.csv'), :test)
else
  puts 'Importando arquivo csv. Aguarde...'
  FileImport.new(File.open('csv/data1.csv'), :development)
end
