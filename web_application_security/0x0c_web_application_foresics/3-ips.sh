#!/bin/bash

# Extract all IPs with successful logins, count unique ones
grep "Accepted password for root" auth.log | awk '{print $(NF-3)}' | sort | uniq | wc -l

