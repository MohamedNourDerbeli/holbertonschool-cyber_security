#!/bin/bash

TARGET="$1"

# Run Nmap with the http-vuln-cve2017-5638 NSE script
nmap --script http-vuln-cve2017-5638 -p 80,443 "$TARGET" -oN vuln_scan_results.txt
