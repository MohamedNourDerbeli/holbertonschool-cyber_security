# 4-write_file.rb

require 'json'

def merge_json_files(file1_path, file2_path)
  # Read and parse both JSON files
  json1 = JSON.parse(File.read(file1_path))
  json2 = JSON.parse(File.read(file2_path))

  # Merge the arrays
  merged = json2 + json1

  # Write merged content back to file2_path
  File.write(file2_path, JSON.pretty_generate(merged))
end
