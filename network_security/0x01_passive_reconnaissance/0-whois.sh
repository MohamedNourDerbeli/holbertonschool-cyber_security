#!/bin/bash
whois $1 | awk '/^(Registrant|Admin|Tech)/ {print}' | sed 's/: /,/' | sed 's/Ext:/Ext:,/' > $1.csv
