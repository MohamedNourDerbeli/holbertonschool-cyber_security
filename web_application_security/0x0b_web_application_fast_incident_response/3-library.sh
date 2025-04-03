#!/bin/bash

# Define the log file
LOG_FILE="logs.txt"

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: $LOG_FILE not found!" >&2
    exit 1
fi

# Find the attacker IP (the one with most requests)
ATTACKER_IP=$(grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}')

# Extract the most common User-Agent for this IP
USER_AGENT=$(grep "$ATTACKER_IP" "$LOG_FILE" | awk -F'"' '{print $6}' | sort | uniq -c | sort -nr | head -n1 | sed 's/^ *[0-9]* *//')

# Display the result
echo "$USER_AGENT"
