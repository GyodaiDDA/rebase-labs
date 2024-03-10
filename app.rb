require 'csv'
require 'sinatra'
require 'sinatra/json'
require_relative 'helpers/import_csv_helper'
require_relative 'helpers/database_helper'

set :bind, '0.0.0.0'

get '/tests' do
  conn = connect_to_database(Sinatra::Application.environment.to_s)
  return json [200, 'Nenhum dado foi importado ainda'] unless table_exists?(conn, 'exams')

  data = []
  query = <<-SQL
            SELECT * FROM exams
              INNER JOIN test_results
                ON exams.id = test_results.exam_id
              LEFT JOIN test_types
                ON test_results.test_type_id = test_types.id
              LEFT JOIN patients
                ON exams.patient_id = patients.id
              LEFT JOIN doctors
                ON exams.doctor_id = doctors.id
  SQL
  result = conn.exec(query)
  result.each { |row| data << row }
  json data
end