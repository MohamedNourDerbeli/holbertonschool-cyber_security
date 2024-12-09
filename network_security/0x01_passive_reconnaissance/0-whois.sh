#!/bin/bash
whois $1 | awk '/^(Registrant|Admin|Tech)/ {print}' | sed 's/: /,/' > $1.csv
