require 'spec_helper'
require 'csv'
require 'pg'

describe 'CSV import script' do
  before(:each) do
    reset_database(:test)
  end

  after(:each) do
    reset_database(:test)
  end

  it 'should save data on database' do
    system 'ruby import_from_csv.rb test'

    conn = connect_to_database(:test)
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
    content = conn.exec(query).map(&:to_h)
    expect(content.size).to eq(3)
    expect(content.first['cpf']).to eq('04897317088')
    expect(content.first['token']).to eq('IQCZ17')
    expect(content.last['test_type']).to eq('hemácias')
    expect(content.last['email']).to eq('rayford@kemmer-kunze.info')
    expect(content.last['test_result']).to eq('28')
    conn.close
  end
end
