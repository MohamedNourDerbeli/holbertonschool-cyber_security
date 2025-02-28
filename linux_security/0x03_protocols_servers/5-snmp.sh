#!/bin/bash
grep -E '^(com2sec|rocommunity)\s+.*\bpublic\b' /etc/snmp/snmpd.conf | grep -E "default|$1"
