require 'spec_helper'
require 'csv'
require 'pg'


describe 'CSV import script' do
  before(:all) { clean_database(:test) }
  after(:all) { clean_database(:test) }
  
  it 'should save data on database' do
    data = CSV.generate do |csv|
      csv << ['Patient','Exam','Result']
      csv << ['Carl','Blood Type', 'O+']
      csv << ['Johanna', 'GIF pronunciation','failed']
    end
    File.write('test_file.csv', data)
  
    allow_any_instance_of(Object).to receive(:gets).and_return("test_file.csv\n")
    load 'import_from_csv.rb'
    
    conn = connect_to_database(:test)
    content = conn.exec('SELECT * FROM imported').map(&:to_h)
    expect(content.size).to eq(2)
    expect(content[1]['patient']).to eq('Johanna')
    expect(content[0]['patient']).to eq('Carl')
    expect(content[1]['exam']).to eq('GIF pronunciation')
    expect(content[0]['exam']).to eq('Blood Type')
    expect(content[1]['result']).to eq('failed')
    expect(content[0]['result']).to eq('O+')
    conn.close
  end
end
