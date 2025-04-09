#!/bin/bash

# Extract all IPs with successful logins, count unique ones
grep "Accepted" auth.log | grep "sshd" | awk '{print $11}' | sort -u | wc -l
