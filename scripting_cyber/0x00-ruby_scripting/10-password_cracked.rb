require 'digest'

# Ensure correct number of arguments
if ARGV.length != 2
  puts "Usage: #{$PROGRAM_NAME} HASHED_PASSWORD DICTIONARY_FILE"
  exit
end

hashed_password = ARGV[0]
dictionary_file = ARGV[1]

# Read the dictionary file
begin
  dictionary = File.readlines(dictionary_file).map(&:chomp)
rescue => e
  puts "Error reading dictionary file: #{e.message}"
  exit
end

# Try to find a match
found = false
dictionary.each do |word|
  # Hash the current word using SHA-256
  hashed_word = Digest::SHA256.hexdigest(word)

  if hashed_word == hashed_password
    puts "Password found: #{word}"
    found = true
    break
  end
end

# If no match was found
puts "Password not found in dictionary." unless found
