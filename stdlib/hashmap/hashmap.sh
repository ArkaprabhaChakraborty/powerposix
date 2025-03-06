#!/bin/sh

# Hashmap Manager - POSIX-compliant key-value storage
# Usage: Source this file and use the functions below

# Initialize hashmap
# Usage: hashmap_init <name>
hashmap_init() {
    mapname="$1"
    mkdir -p "/tmp/hashmaps/$mapname"
}

# Set key-value pair
# Usage: hashmap_set <mapname> <key> <value>
hashmap_set() {
    mapname="$1"
    key="$2"
    value="$3"
    sanitized_key=$(echo "$key" | tr -c '[:alnum:]' '_')
    echo "$value" > "/tmp/hashmaps/$mapname/$sanitized_key"
}

# Get value by key
# Usage: hashmap_get <mapname> <key>
hashmap_get() {
    mapname="$1"
    key="$2"
    sanitized_key=$(echo "$key" | tr -c '[:alnum:]' '_')
    cat "/tmp/hashmaps/$mapname/$sanitized_key" 2>/dev/null
}

# Check if key exists
# Usage: hashmap_has <mapname> <key>
hashmap_has() {
    mapname="$1"
    key="$2"
    sanitized_key=$(echo "$key" | tr -c '[:alnum:]' '_')
    [ -f "/tmp/hashmaps/$mapname/$sanitized_key" ]
}

# Delete key
# Usage: hashmap_del <mapname> <key>
hashmap_del() {
    mapname="$1"
    key="$2"
    sanitized_key=$(echo "$key" | tr -c '[:alnum:]' '_')
    rm -f "/tmp/hashmaps/$mapname/$sanitized_key"
}

# List all keys
# Usage: hashmap_keys <mapname>
hashmap_keys() {
    mapname="$1"
    ls "/tmp/hashmaps/$mapname" 2>/dev/null | while read -r file; do
        echo "$file" | tr '_' ' '  # Approximation of original key
    done
}

# Destroy entire hashmap
# Usage: hashmap_destroy <mapname>
hashmap_destroy() {
    mapname="$1"
    rm -rf "/tmp/hashmaps/$mapname"
}

# Count number of entries
# Usage: hashmap_count <mapname>
hashmap_count() {
    mapname="$1"
    ls -1 "/tmp/hashmaps/$mapname" 2>/dev/null | wc -l
}