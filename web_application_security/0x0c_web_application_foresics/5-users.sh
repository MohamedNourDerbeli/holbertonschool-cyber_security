#!/bin/bash

grep "useradd" auth.log | awk -F'name=' '{print $2}' | cut -d',' -f1 | sort | uniq | paste -sd, -
