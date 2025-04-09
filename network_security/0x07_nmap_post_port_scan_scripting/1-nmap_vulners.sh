#!/bin/bash


TARGET="$1"


# Run Nmap with the vulners NSE script on ports 80 and 443
nmap -p 80,443 --script vulners "$TARGET"
