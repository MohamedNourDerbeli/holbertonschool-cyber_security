#!/bin/bash

if [ -z "$1" ]; then
    exit 1
fi

TARGET="$1"

nmap --script http-vuln-cve2017-5638 -p 80,443 "$TARGET" -oN comprehensive_scan_results.txt
nmap --script ssl-enum-ciphers -p 443 "$TARGET" >> comprehensive_scan_results.txt
nmap --script ftp-anon -p 21 "$TARGET" >> comprehensive_scan_results.txt
