CREATE TABLE IF NOT EXISTS patients (
     id SERIAL PRIMARY KEY,
     cpf VARCHAR(12) NOT NULL,
     full_name VARCHAR(80),
     email VARCHAR(80),
     birthday DATE,
     addresses VARCHAR(120),
     city VARCHAR(80),
     province VARCHAR(20),
     UNIQUE (cpf)
);

CREATE TABLE IF NOT EXISTS doctors (
     id SERIAL PRIMARY KEY,
     crm VARCHAR(10) NOT NULL,
     province VARCHAR(20) NOT NULL,
     full_name VARCHAR(80),
     email VARCHAR(80),
     UNIQUE (crm)
);

CREATE TABLE IF NOT EXISTS exams (
     id SERIAL PRIMARY KEY,
     token VARCHAR(6) NOT NULL,
     exam_date DATE NOT NULL,
     patient_id INTEGER NOT NULL,
     doctor_id INTEGER NOT NULL,
     CONSTRAINT fk_exam_patient FOREIGN KEY (patient_id) REFERENCES patients (id),
     CONSTRAINT fk_exam_doctor FOREIGN KEY (doctor_id) REFERENCES doctors (id),
     UNIQUE (token)
);

CREATE TABLE IF NOT EXISTS test_types (
     id SERIAL PRIMARY KEY,
     test_type VARCHAR(30) NOT NULL,
     test_type_limits VARCHAR(20),
     UNIQUE (test_type)

);

CREATE TABLE IF NOT EXISTS test_results (
     id SERIAL PRIMARY KEY,
     test_type_id INTEGER NOT NULL,
     exam_id INTEGER NOT NULL,
     test_result VARCHAR(30) NOT NULL,
     CONSTRAINT fk_test_type_result FOREIGN KEY (test_type_id) REFERENCES test_types (id),
     CONSTRAINT fk_exam_result FOREIGN KEY (exam_id) REFERENCES exams (id),
     UNIQUE (test_type_id, exam_id)
);
