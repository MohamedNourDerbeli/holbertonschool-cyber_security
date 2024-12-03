#!/bin/bash
if [ "$(id -u)" -eq 0 ]; then
    last -n 5
fi
