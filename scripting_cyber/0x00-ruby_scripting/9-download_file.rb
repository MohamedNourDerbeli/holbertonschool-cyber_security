require 'open-uri'
require 'uri'
require 'fileutils'

# Ensure correct number of arguments
if ARGV.length != 2
  puts "Usage: #{$PROGRAM_NAME} URL LOCAL_FILE_PATH"
  exit
end

url = ARGV[0]
local_path = ARGV[1]

begin
  # If the provided path is a directory, use the filename from the URL
  if File.directory?(local_path)
    local_path = File.join(local_path, File.basename(URI.parse(url).path))
  end

  puts "Downloading file from #{url}..."

  uri = URI.parse(url)

  # Create the directory if it doesn't exist
  FileUtils.mkdir_p(File.dirname(local_path))

  # Download and write file
  URI.open(uri) do |remote_file|
    File.open(local_path, 'wb') do |local_file|
      local_file.write(remote_file.read)
    end
  end

  puts "File downloaded and saved to #{local_path}."
rescue => e
  puts "Error: #{e.message}"
end
