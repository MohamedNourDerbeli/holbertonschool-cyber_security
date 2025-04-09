#!/bin/bash

# Simple SSH log analyzer that counts message patterns
# Usage: ./0-service.sh

LOG_FILE="auth.log"

if [ ! -f "$LOG_FILE" ]; then
  echo "Error: $LOG_FILE not found"
  exit 1
fi

# Process the log file and count patterns
grep "sshd" "$LOG_FILE" | \
  sed -E 's/.*(pam_unix\(sshd:[^:]*).*/\1:/' | \
  sed -E 's/.*(Failed|Invalid|Accepted|error:|Received|PAM|Bad|Exiting|Server|subsystem|reverse|Address|Did|new|changed|change|syslogin_perform_logout:|[A-Z][a-z]+).*/\1/' | \
  sort | uniq -c | sort -nr | \
  awk '{printf "%6d %s\n", $1, $2}'

exit 0
