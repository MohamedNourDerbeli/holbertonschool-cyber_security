#!/bin/bash

# Check if the host argument is provided
if [ -z "$1" ]; then
    exit 1
fi

TARGET="$1"

# Perform the comprehensive scan: OS detection, version detection, script scanning, and traceroute
nmap -O -sV --script=default -T4 "$TARGET" -oN service_enumeration_results.txt

# Sequentially run additional NSE scripts for service enumeration and vulnerability detection

# Retrieve service banners from open ports
nmap --script="banner" -p- "$TARGET" >> service_enumeration_results.txt

# Enumerate supported SSL/TLS ciphers
nmap --script="ssl-enum-ciphers" -p 443 "$TARGET" >> service_enumeration_results.txt

# Run default Nmap scripts for basic enumeration tasks
nmap --script="default" "$TARGET" >> service_enumeration_results.txt

# Enumerate SMB (Server Message Block) domains
nmap --script="smb-enum-domains" -p 445 "$TARGET" >> service_enumeration_results.txt
