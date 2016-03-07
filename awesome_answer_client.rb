require 'faraday'
require 'json'

conn = Faraday.new(:url => 'http://localhost:3000') do |faraday|
  faraday.request :url_encoded
  faraday.response :logger
  faraday.adapter Faraday.default_adapter
end

response = conn.get '/api/v1/questions' #GET http://localhost:3000/api/v1/questions

parsed_body = JSON.parse(response.body)

parsed_body['questions'].each do |question_hash|
  puts question_hash["title"]
end
