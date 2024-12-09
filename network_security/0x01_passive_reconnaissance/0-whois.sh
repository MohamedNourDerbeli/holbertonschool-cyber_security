#!/bin/bash
whois $1 | awk -F":" '{if ($0 ~ /^Registrant/ || $0 ~ /^Admin/ || $0 ~ /^Tech/) {print $0}}' > "$1.csv"
