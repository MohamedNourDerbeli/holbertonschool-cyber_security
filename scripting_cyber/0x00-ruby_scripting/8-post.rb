# 8-post.rb

require 'net/http'
require 'uri'

def post_request(url, body_params)
  uri = URI.parse(url)
  
  # Send the POST request with form parameters
  response = Net::HTTP.post_form(uri, body_params)
  
  # Print the status code and message
  puts "Response status: #{response.code} #{response.message}"
  
  # Print the body of the response
  puts "Response body:\n#{response.body}"
end
