#!/usr/bin/python3
"""
Advanced process heap string replacement tool.

Features:
- Safe memory modification
- Comprehensive error checking
- Support for multiple replacements
- Detailed progress reporting

Usage:
    sudo ./read_write_heap.py pid search_string replace_string

Example:
    sudo ./read_write_heap.py 1234 "old_text" "new_text"
"""

import sys
import os
from typing import Tuple

def validate_inputs(pid: str, search_str: str, replace_str: str) -> Tuple[int, str, str]:
    """Validate and convert all inputs to required formats."""
    try:
        pid_int = int(pid)
        if pid_int <= 0:
            raise ValueError("PID must be positive")
    except ValueError:
        sys.exit(f"Error: Invalid PID '{pid}'. Must be positive integer.")

    if not search_str:
        sys.exit("Error: Search string cannot be empty.")

    if len(replace_str) > len(search_str):
        sys.exit("Error: Replacement string cannot be longer than search string.")

    try:
        search_str.encode('ascii')
        replace_str.encode('ascii')
    except UnicodeEncodeError:
        sys.exit("Error: Both strings must be ASCII.")

    return pid_int, search_str, replace_str

def locate_heap(pid: int) -> Tuple[int, int]:
    """Find heap memory region for given PID."""
    maps_path = f"/proc/{pid}/maps"
    try:
        with open(maps_path, 'r') as f:
            for line in f:
                if '[heap]' in line:
                    parts = line.split()
                    addr_range = parts[0].split('-')
                    return int(addr_range[0], 16), int(addr_range[1], 16)
    except FileNotFoundError:
        sys.exit(f"Error: Process {pid} not found or no permission.")
    except Exception as e:
        sys.exit(f"Error accessing {maps_path}: {str(e)}")

    sys.exit("Error: Heap segment not found in process memory.")

def replace_in_memory(pid: int, heap_start: int, heap_end: int, 
                     search_bytes: bytes, replace_bytes: bytes) -> int:
    """Perform the actual memory replacement."""
    mem_path = f"/proc/{pid}/mem"
    replacements = 0
    
    try:
        with open(mem_path, 'r+b') as mem_file:
            # Read entire heap
            mem_file.seek(heap_start)
            heap_data = mem_file.read(heap_end - heap_start)
            
            # Find all occurrences
            offset = 0
            while True:
                pos = heap_data.find(search_bytes, offset)
                if pos == -1:
                    break
                    
                # Calculate absolute position
                abs_pos = heap_start + pos
                mem_file.seek(abs_pos)
                mem_file.write(replace_bytes.ljust(len(search_bytes), b'\x00'))
                replacements += 1
                offset = pos + 1
                
    except PermissionError:
        sys.exit("Error: Permission denied. Try with sudo.")
    except Exception as e:
        sys.exit(f"Memory access error: {str(e)}")
        
    return replacements

def main():
    if len(sys.argv) != 4:
        sys.exit("Usage: sudo ./read_write_heap.py pid search_string replace_string")

    pid, search_str, replace_str = validate_inputs(*sys.argv[1:4])
    heap_start, heap_end = locate_heap(pid)
    
    print(f"[*] Targeting PID {pid}")
    print(f"[*] Heap located at 0x{heap_start:x}-0x{heap_end:x}")
    
    replacements = replace_in_memory(
        pid,
        heap_start,
        heap_end,
        search_str.encode(),
        replace_str.encode()
    )
    
    if replacements > 0:
        print(f"[+] Successfully made {replacements} replacement(s)")
    else:
        print("[-] No replacements made - string not found")

if __name__ == "__main__":
    main()
