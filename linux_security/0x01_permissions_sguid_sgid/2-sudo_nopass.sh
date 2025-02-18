#!/bin/bash
echo "$username ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
