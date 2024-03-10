require_relative 'helpers/import_csv_helper'

if ARGV.length > 0
 FileImport.new('csv/test_file.csv', :test)
else
 puts "Importando arquivo csv. Aguarde..."
 FileImport.new('csv/data1.csv', :development)
end