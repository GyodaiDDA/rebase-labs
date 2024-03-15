require 'spec_helper'
require 'csv'
require 'pg'

describe 'CSV import script' do
  before(:each) do
    reset_database(:test)
  end

  it 'should save data on database' do
    system 'ruby import_from_csv.rb test'

    conn = connect_to_database(:test)
    query = File.read('queries/list_exams.sql')
    content = conn.exec(query).map(&:to_h)
    expect(content.size).to eq(3)
    expect(content.first['cpf']).to eq('04888317088')
    expect(content.first['result_token']).to eq('ICQ123')
    expect(JSON.parse(content.last['tests'])[0]['test']).to eq('tgp')
    expect(JSON.parse(content.last['doctor'])['crm']).to eq('B00023FM66')
    expect(JSON.parse(content.last['tests'])[0]['result']).to eq('238')
    conn.close
  end

  it 'should not send repeated data' do
    system 'ruby import_from_csv.rb test'
    conn = connect_to_database(:test)
    query = File.read('queries/list_exams.sql')

    content = conn.exec(query).map(&:to_h)
    expect(content.size).to eq(3)
    conn.close
  end
end
