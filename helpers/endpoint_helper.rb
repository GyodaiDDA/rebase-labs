require 'sinatra'
require 'sinatra/base'
require_relative 'import_csv_helper'

def get_exams_by_tokens(conn, params)
  query = File.open("queries/exams_by_token.sql").read
  results = []
  tokens = params['tokens'].split(',')
  tokens.each do |token|
    results << conn.exec_params(query, [token]).entries
  end
  results.reject! { |result| result.empty? }
  halt(404,{'Content-Type' => 'application/json'}, 'Token não encontrado') if results.empty?
  data = {results: }
  data[:results].each do |row|
    %w[doctor tests].each { |key| row[0][key] = JSON.parse(row[0][key]) if row[0][key] }
  end
  data
end

def get_exams_list(conn)
  query = File.open('queries/list_exams.sql').read
  results = conn.exec(query).entries
  data = { results: }
  data[:results].each do |row|
    %w[doctor tests].each { |key| row[key] = JSON.parse(row[key]) if row[key] }
  end
  data
end
