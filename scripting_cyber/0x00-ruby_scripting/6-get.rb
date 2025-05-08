require 'net/http'

def get_request(url)
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    puts "Response body:\n#{res.body if res.is_a?(Net::HTTPSuccess)}"
end
