#!/bin/bash
# awk '!/^#/ && NF' /etc/ssh/sshd_config
grep -E -v '^#|^$' filename
