#!/bin/bash

grep "useradd" auth.log | awk -F'name=' '{print $2}' | sort | uniq | cut -d',' -f1 | paste -sd, -
