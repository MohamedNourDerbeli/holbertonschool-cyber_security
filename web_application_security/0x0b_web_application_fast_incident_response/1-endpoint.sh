#!/bin/bash

# Check if log file exists
if [ ! -f "logs.txt" ]; then
    echo "Error: logs.txt file not found!"
    exit 1
fi

# Extract endpoints, count occurrences, and sort by count
endpoint_count=$(awk '{print $7}' logs.txt | sort | uniq -c | sort -nr)

# Get the endpoint with the highest count
top_endpoint=$(echo "$endpoint_count" | head -n 1 | awk '{print $2}')

# Display the result
echo "$top_endpoint"
