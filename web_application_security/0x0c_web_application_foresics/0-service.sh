#!/bin/bash

# Define the log file to analyze
LOG_FILE="/var/log/auth.log"

# Analyze the log file for service-related entries
grep -E "sshd|pam_unix|systemd" "$LOG_FILE" | \
    awk '{print $5}' | \
    sed 's/[:,]//g' | \
    sort | \
    uniq -c | \
    sort -nr
