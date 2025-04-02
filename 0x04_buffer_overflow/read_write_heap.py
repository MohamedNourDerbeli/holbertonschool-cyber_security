#!/usr/bin/env python3
"""
Script to find and replace a string in the heap of a running process.
"""

import sys
import os
import re

def print_error(message):
    """Print error message and exit with status 1."""
    print(f"Error: {message}", file=sys.stderr)
    sys.exit(1)

def read_write_heap(pid, search_str, replace_str):
    """
    Find and replace a string in the heap of a process.
    
    Args:
        pid: Process ID
        search_str: String to search for
        replace_str: String to replace with
    """
    # Validate the replacement string is not longer than the search string
    if len(replace_str) > len(search_str):
        print_error("Replacement string cannot be longer than search string")
    
    # Pad the replacement string with null bytes if it's shorter
    replace_str_padded = replace_str.ljust(len(search_str), '\x00')
    
    # Path to the process's memory maps
    maps_path = f"/proc/{pid}/maps"
    # Path to the process's memory
    mem_path = f"/proc/{pid}/mem"
    
    try:
        # Read the memory maps to find the heap
        with open(maps_path, 'r') as maps_file:
            heap_info = None
            for line in maps_file:
                if '[heap]' in line:
                    heap_info = line.split()
                    break
            
            if not heap_info:
                print_error("Could not find heap in process memory maps")
            
            # Extract heap start and end addresses
            addr_range = heap_info[0].split('-')
            heap_start = int(addr_range[0], 16)
            heap_end = int(addr_range[1], 16)
            
            # Extract permissions (we need read and write)
            perms = heap_info[1]
            if 'r' not in perms or 'w' not in perms:
                print_error("Heap does not have read and write permissions")
    
    except IOError as e:
        print_error(f"Could not read memory maps: {e}")
    
    try:
        # Open the memory file for reading and writing
        with open(mem_path, 'rb+') as mem_file:
            # Seek to the start of the heap
            mem_file.seek(heap_start)
            
            # Read the entire heap
            heap_data = mem_file.read(heap_end - heap_start)
            
            # Search for the string in the heap
            search_bytes = search_str.encode('ASCII')
            replace_bytes = replace_str_padded.encode('ASCII')
            
            matches = []
            offset = 0
            while True:
                # Find the next occurrence of the search string
                found = heap_data.find(search_bytes, offset)
                if found == -1:
                    break
                
                matches.append(found)
                offset = found + 1
            
            if not matches:
                print_error(f"Could not find string '{search_str}' in heap")
            
            print(f"Found {len(matches)} occurrence(s) of '{search_str}' in heap")
            
            # Replace each occurrence
            for offset_in_heap in matches:
                # Calculate the absolute address
                absolute_address = heap_start + offset_in_heap
                
                # Seek to the location and write the replacement
                mem_file.seek(absolute_address)
                mem_file.write(replace_bytes)
                
                print(f"Replaced at address: 0x{absolute_address:x}")
    
    except IOError as e:
        print_error(f"Could not access process memory: {e}")
    except PermissionError as e:
        print_error(f"Permission denied (try running as root): {e}")

if __name__ == "__main__":
    # Check command line arguments
    if len(sys.argv) != 4:
        print("Usage: read_write_heap.py pid search_string replace_string")
        sys.exit(1)
    
    try:
        pid = int(sys.argv[1])
        search_str = sys.argv[2]
        replace_str = sys.argv[3]
        
        # Validate strings are ASCII
        try:
            search_str.encode('ASCII')
            replace_str.encode('ASCII')
        except UnicodeEncodeError:
            print_error("Strings must be ASCII")
        
        read_write_heap(pid, search_str, replace_str)
        print("Replacement completed successfully")
    
    except ValueError:
        print_error("PID must be an integer")
