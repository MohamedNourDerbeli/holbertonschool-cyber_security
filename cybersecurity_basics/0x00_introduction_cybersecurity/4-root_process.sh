#!/bin/bash
ps aux | grep "^$1" | grep -v "^\S* \S* 0[[:space:]]*0"
