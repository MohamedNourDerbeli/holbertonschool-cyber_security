#!/bin/bash
nmap --script http-vuln-cve2017-5638 -p 80,443 "$1" -oN comprehensive_scan_results.txt && nmap --script ssl-enum-ciphers -p 443 "$1" >> comprehensive_scan_results.txt
nmap --script ftp-anon -p 21 "$1" >> comprehensive_scan_results.txt
