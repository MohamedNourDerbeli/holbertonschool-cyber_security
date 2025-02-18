#!/bin/bash
find "$target_directory" -type f -perm -4000 2>/dev/null
