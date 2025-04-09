#!/bin/bash


grep "useradd" auth.log| awk '{print $8}' | awk -F= '{print $2}' | sort | paste -sd -
