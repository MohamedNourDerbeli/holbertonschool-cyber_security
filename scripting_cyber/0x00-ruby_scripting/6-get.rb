require 'net/http'
require 'json'
require 'uri'

def get_request(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    
    puts "Response status: #{response.code} #{response.message}"

  begin
    parsed_body = JSON.parse(response.body)
    puts "Response body:\n#{JSON.pretty_generate(parsed_body)}"
  rescue JSON::ParserError
    puts "Response body:\n#{response.body}"
  end
end
