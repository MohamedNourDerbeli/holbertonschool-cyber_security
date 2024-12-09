#!/bin/bash
whois $1 | awk '{if ($0 ~ /^Registrant/) section="Registrant"; if ($0 ~ /^Admin/) section="Admin"; if ($0 ~ /^Tech/) section="Tech"; if ($0 == "") section=""; if (section) {gsub(/ /,"$",$0); print section"$"$0}}' > "$1.csv"
