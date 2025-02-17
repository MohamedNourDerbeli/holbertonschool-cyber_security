#!/bin/bash
john --wordlist=rockyou.txt --format=Raw-MD5 $1
