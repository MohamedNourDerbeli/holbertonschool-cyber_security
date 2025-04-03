#!/bin/bash

# Check if log file exists
if [ ! -f "logs.txt" ]; then
    echo "Error: logs.txt file not found!"
    exit 1
fi

# Extract IP addresses, count occurrences, and sort by count
ip_count=$(grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' logs.txt | sort | uniq -c | sort -nr)

# Get the IP with the highest count
top_ip=$(echo "$ip_count" | head -n 1 | awk '{print $2}')

# Display the result
echo "$top_ip"
