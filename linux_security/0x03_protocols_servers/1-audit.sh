#!/bin/bash
awk '!/^#/ && NF' /etc/ssh/sshd_config
