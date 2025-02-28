#!/bin/bash
grep -q "^smtpd_tls_security_level\s*=\s*encrypt" /etc/postfix/main.cf || echo "STARTTLS not configured"
