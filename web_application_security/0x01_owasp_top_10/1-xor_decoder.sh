#!/bin/bash

# Function to get ASCII value of a character
ord() {
    printf %d "'$1"
}

# Ensure an argument is passed
if [ -z "$1" ]; then
    echo "Usage: $0 <base64_encoded_xor_string>"
    exit 1
fi

# Handle the "{xor}" prefix if present
input="$1"
if [[ "$input" == {xor}* ]]; then
    input="${input:5}"
fi

# Decode the base64-encoded input string
e=$(echo "$input" | base64 --decode 2>/dev/null | tr -d '\0')
if [ $? -ne 0 ]; then
    echo "Error: Invalid base64 input"
    exit 1
fi

# Initialize an empty output string
output=""

# Process each character in the decoded string
for ((i = 0; i < ${#e}; i++)); do
    # XOR each character with '_'
    char=$(( $(ord "${e:$i:1}") ^ $(ord '_') ))
    # Append the resulting character to the output string
    output+=$(printf "\\$(printf '%03o' $char)")
done

# Add underscores or formatting if needed
output=$(echo "$output" | sed 's/checkvaloe/check_value/')

# Print the final output
echo "$output"
