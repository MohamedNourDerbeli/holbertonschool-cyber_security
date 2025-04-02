#!/usr/bin/env python3
"""
Script to find and replace a string in the heap of a running process.

Usage: read_write_heap.py pid search_string replace_string
"""

import sys
import os

def print_error(message):
    """Print error message and exit with status 1."""
    print(f"Error: {message}", file=sys.stderr)
    sys.exit(1)

def validate_inputs(pid, search_str, replace_str):
    """Validate all input parameters."""
    if not isinstance(pid, int) or pid <= 0:
        print_error("PID must be a positive integer")
    
    if not search_str:
        print_error("Search string cannot be empty")
    
    if '\x00' in search_str or '\x00' in replace_str:
        print_error("Strings cannot contain null bytes")
    
    try:
        search_str.encode('ascii')
        replace_str.encode('ascii')
    except UnicodeEncodeError:
        print_error("Strings must be ASCII")

def read_write_heap(pid, search_str, replace_str):
    """Main heap replacement function."""
    validate_inputs(pid, search_str, replace_str)
    
    if len(replace_str) > len(search_str):
        print_error("Replacement string cannot be longer than search string")
    
    replace_str_padded = replace_str.ljust(len(search_str), '\x00')
    
    maps_path = f"/proc/{pid}/maps"
    mem_path = f"/proc/{pid}/mem"
    
    try:
        with open(maps_path, 'r') as maps_file:
            for line in maps_file:
                if '[heap]' in line:
                    heap_info = line.split()
                    break
            else:
                print_error("Could not find heap in process memory maps")
            
            addr_range = heap_info[0].split('-')
            heap_start = int(addr_range[0], 16)
            heap_end = int(addr_range[1], 16)
            
            if 'r' not in heap_info[1] or 'w' not in heap_info[1]:
                print_error("Heap does not have read+write permissions")
            
            if heap_start <= 0 or heap_end <= 0:
                print_error("Invalid heap memory addresses")

    except IOError as e:
        print_error(f"Cannot access process {pid}: {e}")
    
    try:
        with open(mem_path, 'rb+') as mem_file:
            heap_size = heap_end - heap_start
            if heap_size > 10000000:  # 10MB sanity check
                print_error("Abnormally large heap - possible error")
            
            mem_file.seek(heap_start)
            heap_data = mem_file.read(heap_size)
            
            search_bytes = search_str.encode('ascii')
            replace_bytes = replace_str_padded.encode('ascii')
            
            matches = []
            offset = 0
            while True:
                found = heap_data.find(search_bytes, offset)
                if found == -1:
                    break
                if found + len(search_bytes) > heap_size:
                    print_error("String at heap boundary - skipping")
                    break
                matches.append(found)
                offset = found + 1
            
            if not matches:
                print_error(f"'{search_str}' not found in heap")
            
            print(f"Found {len(matches)} occurrence(s)")
            
            for offset_in_heap in matches:
                absolute_address = heap_start + offset_in_heap
                mem_file.seek(absolute_address)
                mem_file.write(replace_bytes)
                print(f"Replaced at 0x{absolute_address:x}")

    except PermissionError:
        print_error("Permission denied - try with sudo")
    except Exception as e:
        print_error(f"Unexpected error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: read_write_heap.py pid search_string replace_string")
        sys.exit(1)
    
    try:
        pid = int(sys.argv[1])
        read_write_heap(pid, sys.argv[2], sys.argv[3])
        print("Replacement completed successfully")
    except ValueError:
        print_error("PID must be an integer")
