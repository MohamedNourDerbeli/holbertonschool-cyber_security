#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {xor}encoded_hash"
    exit 1
fi

# Extract the encoded part of the hash (remove the {xor} prefix)
sliced_password="${1#"{xor}"}"

# Decode the base64 encoded hash (suppress warnings)
decoded_base64=$(echo -n "$sliced_password" | base64 --decode 2>/dev/null)

# Check if base64 decoding succeeded
if [ $? -ne 0 ]; then
    echo "Error: Failed to decode Base64 input."
    exit 1
fi

# XOR decode the hash with the key '_' (ASCII value 95)
decoded_password=""
for ((i=0; i<${#decoded_base64}; i++)); do
    char=${decoded_base64:i:1}
    ascii_value=$(printf "%d" "'$char'")
    xor_value=$((ascii_value ^ 95))
    xor_char=$(printf "\\$(printf '%03o' "$xor_value")")
    decoded_password+="$xor_char"
done

# Output the decoded password
echo "$decoded_password"
