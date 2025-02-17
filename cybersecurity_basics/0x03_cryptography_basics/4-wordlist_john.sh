#!/bin/bash
john --wordlist=rockyou.txt --format=raw-md5 $1
