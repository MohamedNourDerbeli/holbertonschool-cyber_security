#!/bin/bash
sudo nmap -sF -f -T 2 -p 80-85 $1
