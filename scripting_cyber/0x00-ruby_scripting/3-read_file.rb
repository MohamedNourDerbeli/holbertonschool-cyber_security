# 3-read_file.rb

require 'json'

def count_user_ids(path)
  # Read and parse the JSON file
  data = JSON.parse(File.read(path))

  # Create a hash to count userId occurrences
  user_id_counts = Hash.new(0)

  # Iterate through each object in the JSON array
  data.each do |entry|
    user_id = entry['userId']
    user_id_counts[user_id] += 1 if user_id
  end

  # Print the counts sorted by userId
  user_id_counts.sort.each do |user_id, count|
    puts "#{user_id}: #{count}"
  end
end
