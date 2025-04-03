# Advanced Heap Memory Editor

## Overview

The Advanced Heap Memory Editor is a sophisticated Python utility designed to safely find and replace strings in a process's heap memory. This tool provides professional-grade memory editing capabilities with comprehensive safety checks, making it suitable for debugging, reverse engineering, and low-level system programming tasks.

## Key Features

- **Safe Memory Editing**: Carefully validates all operations before modifying memory
- **Unicode Support**: Handles both ASCII and Unicode/UTF-8 strings
- **Backup/Restore**: Creates memory backups before making changes
- **Dry Run Mode**: Simulates operations without actual modification
- **Multi-Replacement**: Option to replace all occurrences or just the first
- **Detailed Logging**: Comprehensive operation logging with verbosity control
- **Heap Boundary Protection**: Strict checks to prevent memory corruption

## Installation

**Prerequisites**:
   - Python 3.6 or higher
   - Linux system (uses `/proc` filesystem)
   - Root privileges (for memory access)


## Usage

### Basic Command Structure

```bash
sudo ./advanced_heap_replace.py [OPTIONS] pid search_string replace_string
```

### Options

| Option       | Description                                  |
|--------------|----------------------------------------------|
| `--unicode`  | Enable Unicode string handling               |
| `--dry-run`  | Simulate without making changes             |
| `--backup`   | Create memory backup to specified path      |
| `--verbose`  | Show detailed operation information         |
| `--all`      | Replace all occurrences (default: first)    |

### Examples

1. **Simple ASCII replacement**:
   ```bash
   sudo ./advanced_heap_replace.py 1234 "old" "new"
   ```

2. **Unicode string replacement**:
   ```bash
   sudo ./advanced_heap_replace.py --unicode 5678 "こんにちは" "你好"
   ```

3. **Dry run with backup**:
   ```bash
   sudo ./advanced_heap_replace.py --dry-run --backup /tmp/mem_backup 8910 "password" "p@ssw0rd"
   ```

4. **Replace all occurrences**:
   ```bash
   sudo ./advanced_heap_replace.py --all 1122 "temp" "perm"
   ```

## Safety Features

1. **Memory Validation**:
   - Verifies heap boundaries before any operation
   - Checks memory permissions (read/write)
   - Validates string lengths

2. **Backup System**:
   - Creates complete heap backups before modification
   - Backup files include `.heapbak` extension
   - Stores original memory contents for recovery

3. **Operation Controls**:
   - Maximum heap size limit (100MB default)
   - Explicit permission checking
   - Dry-run mode for testing

## Technical Details

### Memory Access Methodology

The tool uses Linux's `/proc` filesystem to:
1. Locate heap segments via `/proc/[pid]/maps`
2. Access process memory through `/proc/[pid]/mem`
3. Validate memory regions before modification

### String Handling

- **Encoding Support**:
  - ASCII (default)
  - Unicode/UTF-8 (with `--unicode` flag)
- **Length Validation**:
  - Replacement string cannot be longer than search string
  - Automatic null-byte padding for shorter replacements

### Error Handling

Comprehensive error checking for:
- Invalid process IDs
- Permission issues
- Memory access violations
- String encoding problems
- Heap boundary violations

## Development

### Dependencies

- Python 3.6+
- Standard library only (no external dependencies)

### Testing

Recommended test cases:
1. Basic string replacement
2. Unicode string handling
3. Permission validation
4. Boundary condition testing
5. Dry-run verification

### Extending Functionality

To add features:
1. Create new argument parser options
2. Implement functionality in `MemoryEditor` class
3. Add appropriate validation
4. Update documentation


## Warning

⚠️ **Use with caution** ⚠️  
Modifying process memory can cause system instability or crashes. Always:
- Use dry-run mode first
- Create backups
- Test on non-critical processes
- Understand the implications before modifying production systems

## Support

For issues or feature requests, please open an issue on the [GitHub repository](https://github.com/MohamedNourDerbeli/holbertonschool-cyber_security/tree/main/linux_security/0x04_buffer_overflow).
