#!/bin/bash
ps -u $1 -eo user,pid,%cpu,%mem,rss,tty,stat,start,time,command | awk '$5 != 0 && $6 != 0 '
