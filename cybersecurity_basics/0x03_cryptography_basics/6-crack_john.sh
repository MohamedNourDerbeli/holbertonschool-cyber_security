#!/bin/bash
john --wordlist=rockyou.txt --format=Raw-SHA256 $1
