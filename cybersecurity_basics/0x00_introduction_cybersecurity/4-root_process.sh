#!/bin/bash
ps -u $1 aux | awk '$5 != 0 && $6 != 0'
