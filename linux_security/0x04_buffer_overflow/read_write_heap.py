#!/usr/bin/python3
"""
Heap Memory String Replacement Tool

Finds and replaces a string in the heap memory of a running process.

Usage:
    sudo ./read_write_heap.py pid search_string replace_string

Example:
    sudo ./read_write_heap.py 1234 "old_text" "new_text"
"""

import sys
import os

def print_error(message):
    """Print error message and exit with status 1.
    
    Args:
        message (str): Error message to display
    """
    print(f"Error: {message}", file=sys.stderr)
    sys.exit(1)

def validate_inputs(pid, search_str, replace_str):
    """Validate all input parameters.
    
    Args:
        pid (str): Process ID string
        search_str (str): String to search for
        replace_str (str): String to replace with
        
    Returns:
        tuple: (validated_pid, search_bytes, replace_bytes)
    """
    try:
        pid_int = int(pid)
        if pid_int <= 0:
            raise ValueError("PID must be positive")
    except ValueError:
        print_error("PID must be a positive integer")

    if not search_str:
        print_error("Search string cannot be empty")

    if len(replace_str) > len(search_str):
        print_error("Replacement string cannot be longer than search string")

    try:
        search_bytes = search_str.encode('ascii')
        replace_bytes = replace_str.encode('ascii')
    except UnicodeEncodeError:
        print_error("Both strings must be ASCII")

    return pid_int, search_bytes, replace_bytes

def find_and_replace(pid, search_bytes, replace_bytes):
    """Perform the heap memory replacement.
    
    Args:
        pid (int): Process ID
        search_bytes (bytes): Bytes to search for
        replace_bytes (bytes): Bytes to replace with
    """
    mem_path = f"/proc/{pid}/mem"
    maps_path = f"/proc/{pid}/maps"
    
    try:
        with open(maps_path, 'r') as maps_file:
            for line in maps_file:
                if 'heap' in line and 'rw' in line:
                    parts = line.split()
                    start, end = map(lambda x: int(x, 16), parts[0].split('-'))
                    
                    with open(mem_path, 'r+b') as mem_file:
                        mem_file.seek(start)
                        data = mem_file.read(end - start)
                        
                        offset = data.find(search_bytes)
                        if offset != -1:
                            # Ensure we don't write beyond the heap boundary
                            if offset + len(replace_bytes) > len(data):
                                print_error("Replacement would exceed heap boundary")
                            
                            mem_file.seek(start + offset)
                            mem_file.write(replace_bytes)
                            print(f"Successfully replaced at 0x{start + offset:x}")
                            return
                        
            print_error("Search string not found in heap or heap not accessible")
            
    except PermissionError:
        print_error("Permission denied - try running with sudo")
    except FileNotFoundError:
        print_error(f"Process {pid} not found")
    except Exception as e:
        print_error(f"Unexpected error: {str(e)}")

def main():
    """Main execution function."""
    if len(sys.argv) != 4:
        print("Usage: sudo ./read_write_heap.py pid search_string replace_string")
        sys.exit(1)
        
    pid, search_bytes, replace_bytes = validate_inputs(*sys.argv[1:4])
    find_and_replace(pid, search_bytes, replace_bytes)
    print("Operation completed successfully")

if __name__ == "__main__":
    main()
