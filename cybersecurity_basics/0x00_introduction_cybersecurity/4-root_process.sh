#!/bin/bash
ps aux | awk '$5 != 0 && $6 != 0' | grep -v $1
