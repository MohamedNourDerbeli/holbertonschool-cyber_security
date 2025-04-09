#!/bin/bash

# Analyze last 1000 lines of auth.log
comm -12 \
    <(tail -1000 auth.log | grep "sshd" | grep "Failed password" | awk '{print $9}' | sort | uniq) \
    <(tail -1000 auth.log | grep "sshd" | grep "Accepted password" | awk '{print $9}' | sort | uniq)

