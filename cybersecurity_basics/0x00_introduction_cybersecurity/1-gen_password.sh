#!/bin/bash
head -c $1 /dev/urandom | base64 | tr -dc '[:alnum:]'
