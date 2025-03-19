#!/bin/bash
sudo nmap -sM  -p80,443,21,22,23 -v $1
