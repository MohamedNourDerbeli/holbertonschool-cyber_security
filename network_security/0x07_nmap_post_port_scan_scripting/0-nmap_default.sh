#!/bin/bash

TARGET="$1"

nmap -sC -sV -Pn "$TARGET"
