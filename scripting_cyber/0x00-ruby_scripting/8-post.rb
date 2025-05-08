require 'net/http'
require 'uri'
require 'json'

def post_request(url, body_params)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == "https")

  request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
  request.body = body_params.to_json

  response = http.request(request)

  puts "Response status: #{response.code} #{response.message}"

  begin
    parsed = JSON.parse(response.body)
    if parsed.empty?
      puts "Response body:\n{}"
    else
      puts "Response body:\n#{JSON.pretty_generate(parsed)}"
    end
  rescue JSON::ParserError
    puts "Response body:\n#{response.body}"
  end
end
