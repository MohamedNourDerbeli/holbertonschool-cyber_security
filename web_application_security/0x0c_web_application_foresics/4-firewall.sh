#!/bin/bash

grep -i "iptables -A" auth.log | wc -l
