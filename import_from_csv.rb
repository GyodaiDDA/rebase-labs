require_relative 'helpers/import_csv_helper'

puts 'Qual o nome do arquivo? (example.csv)'
file = gets.chomp

if file == 'test_file.csv'
  FileImport.new(file, :test)
elsif File.exist?(file)
  FileImport.new(file, :development)
else
  puts "Arquivo '#{file}' não encontrado"
end