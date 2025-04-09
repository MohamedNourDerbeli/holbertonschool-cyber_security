#!/bin/bash

grep "useradd" auth.log | awk -F'name=' '{print $2}' | sort | cut -d',' -f1 | paste -sd, -
