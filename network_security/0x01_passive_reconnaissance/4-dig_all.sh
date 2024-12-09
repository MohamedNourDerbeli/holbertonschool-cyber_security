#!/bin/bash
record_types=("A" "NS" "SOA" "MX" "TXT")
for record in "${record_types[@]}"; do
    dig $1 $record +noall +answer
done
