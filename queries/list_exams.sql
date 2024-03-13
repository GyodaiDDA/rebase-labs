SELECT
exams.token AS result_token,
exams.exam_date AS result_date,
patients.cpf AS cpf,
patients.full_name AS name,
patients.email AS email,
patients.birthday AS birthday,
json_build_object(
  'crm', doctors.crm, 
  'crm_state', doctors.crm_state,
  'name', doctors.full_name
) AS doctor,
json_agg(
  json_build_object(
    'test', test_types.test_type, 
    'limits', test_types.test_type_limits,
    'result', test_results.test_result
  )
) AS tests
FROM exams
  JOIN patients ON exams.patient_id = patients.id
  JOIN doctors ON exams.doctor_id = doctors.id
  JOIN test_results ON exams.id = test_results.exam_id
  JOIN test_types ON test_results.test_type_id = test_types.id
GROUP BY exams.token, exams.exam_date, patients.cpf, patients.full_name, patients.email, patients.birthday, doctors.crm, doctors.crm_state, doctors.full_name
ORDER BY exam_date DESC;