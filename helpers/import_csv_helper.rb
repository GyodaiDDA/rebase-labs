require 'byebug'
require 'csv'
require 'pg'
require_relative 'database_helper'

class FileImport
  def initialize(csv_file, environment)
    csv_table = CSV.table(csv_file, col_sep: ';')
    csv_table[:cpf] = numbers_only(csv_table[:cpf])
    send_to_database(csv_table, environment)
  end

  def send_to_database(csv_table, environment)
    conn = connect_to_database(environment)
    create_tables(conn)
    populate_tables(conn, csv_table)
    conn.close
    puts 'Dados importados com sucesso.'
  end

  def populate_tables(conn, csv_table)  
    conn.exec("BEGIN")
    patients_prepared = conn.prepare(
      'patients',
      'INSERT INTO patients (cpf, full_name, email, birthday, addresses, city, province)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      ON CONFLICT DO NOTHING
      RETURNING id;'
    )
    doctors_prepared = conn.prepare(
      'doctors',
      "INSERT INTO doctors (crm, province, full_name, email)
      VALUES ($1, $2, $3, $4)
      ON CONFLICT DO NOTHING
      RETURNING id;"
    )
    exams = conn.prepare(
      'exams',
      "INSERT INTO exams (token, exam_date, patient_id, doctor_id)
      VALUES ($1, $2, $3, $4)
      ON CONFLICT DO NOTHING
      RETURNING id;"
    )
    test_types = conn.prepare(
      'test_types',
      "INSERT INTO test_types (test_type, test_type_limits)
      VALUES ($1, $2)
      ON CONFLICT DO NOTHING
      RETURNING id;"
    )
    test_results = conn.prepare('test_results',
      "INSERT INTO test_results (exam_id, test_type_id, test_result)
      VALUES (
        (SELECT id FROM exams WHERE token = $1 LIMIT 1),
        (SELECT id FROM test_types WHERE test_type = $2 LIMIT 1),
        $3)"
    )
    csv_table.each do |row|
      patient_data = row[0..6]
      doctor_data = row[7..10]
      exam_data = row[11..12]
      test_type_data = row[13..14]
      test_result_data = row[15]
      patient = conn.exec_prepared('patients', [patient_data[0], patient_data[1], patient_data[2], patient_data[3], patient_data[4], patient_data[5], patient_data[6]])
      patient_id =  if patient.ntuples.zero?
                      patient_id = conn.exec_params("SELECT id FROM patients WHERE cpf = $1", [patient_data[0]])[0]['id']
                    else
                      patient_id = patient[0]['id']
                    end
      
      doctor = conn.exec_prepared('doctors', [doctor_data[0], doctor_data[1], doctor_data[2], doctor_data[3]])
      doctor_id = if doctor.ntuples.zero?
                    conn.exec_params("SELECT id FROM doctors WHERE crm = $1", [doctor_data[0]])[0]['id']
                  else
                    doctor[0]['id']
                  end

      exam = conn.exec_prepared('exams', [exam_data[0], exam_data[1], patient_id, doctor_id])
      exam_id = if exam.ntuples.zero?
                  conn.exec_params("SELECT id FROM exams WHERE token = $1", [exam_data[0]])[0]['id']
                else
                  exam[0]['id']
                end

      test_type = conn.exec_prepared('test_types', [test_type_data[0], test_type_data[1]])
      test_type_id =  if test_type.ntuples.zero?
                        conn.exec_params("SELECT id FROM test_types WHERE test_type = $1", [test_type_data[0]])[0]['id']
                      else
                        test_type[0]['id']
                      end

      conn.exec_prepared('test_results', [exam_data[0].to_s, test_type_data[0].to_s, test_result_data])
    end
    conn.exec("COMMIT")
  end

  def numbers_only(csv_column)
    csv_column.map do |column|
      column = column.gsub(/[^0-9]/, "")
    end
  end
end
