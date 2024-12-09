#!/bin/bash
whois $1 | awk -F":" '/^(Registrant|Admin|Tech)/ {print $1 "," substr($0, index($0,$2))}' | sed 's/ //g' > $1.csv
