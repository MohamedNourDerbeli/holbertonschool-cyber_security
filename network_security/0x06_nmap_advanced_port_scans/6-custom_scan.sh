#!/bin/bash
sudo nmap -p $2 --scanflags ALL $1 -oN custom_scan.txt > /dev/null 2>&1
