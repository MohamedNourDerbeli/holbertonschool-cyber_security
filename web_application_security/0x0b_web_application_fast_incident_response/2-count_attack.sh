#!/bin/bash


LOG_FILE=logs.txt

# Verify the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file '$LOG_FILE' not found!"
    exit 1
fi

# Find the attacker IP (most frequent in logs)
ATTACKER_IP=$(grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 1)

# Extract the count and IP separately
REQUEST_COUNT=$(echo "$ATTACKER_IP" | awk '{print $1}')
echo "$REQUEST_COUNT"
