#!/bin/sh
# arraylist.sh - A POSIX-compliant ArrayList implementation
# Usage: . ./arraylist.sh

# Default location for the arraylist files
ARRAYLIST_DIR="${ARRAYLIST_DIR:-/tmp/arraylist}"

# Initialize the arraylist
arraylist_init() {
    list_name="${1:-default}"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Create arraylist directory if it doesn't exist
    mkdir -p "${ARRAYLIST_DIR}" 2>/dev/null || return 1
    
    # Initialize or clear the arraylist file
    : > "${list_path}" || return 1
    
    # Set permissions to be readable/writable only by the owner
    chmod 600 "${list_path}" 2>/dev/null
    
    echo "${list_path}"
}

# Add an item to the end of the arraylist
arraylist_add() {
    list_name="${1:-default}"
    item="$2"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        arraylist_init "${list_name}" >/dev/null || return 1
    fi
    
    # Add the item to the end of the arraylist
    printf '%s\n' "${item}" >> "${list_path}" || return 1
    
    # Return the index of the added item (zero-based)
    arraylist_size "${list_name}"
    return 0
}

# Get an item at a specific index
arraylist_get() {
    list_name="${1:-default}"
    index="$2"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        return 1
    fi
    
    # Validate index
    if ! [ "${index}" -ge 0 ] 2>/dev/null; then
        return 1
    fi
    
    # Get the item at the specified index (zero-based)
    # We add 1 because sed uses 1-based indexing
    sed -n "$((index + 1))p" "${list_path}" 2>/dev/null || return 1
    
    return 0
}

# Set an item at a specific index
arraylist_set() {
    list_name="${1:-default}"
    index="$2"
    item="$3"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        return 1
    fi
    
    # Validate index
    if ! [ "${index}" -ge 0 ] 2>/dev/null; then
        return 1
    fi
    
    # Get the current size
    size=$(arraylist_size "${list_name}")
    
    # Check if index is out of bounds
    if [ "${index}" -ge "${size}" ]; then
        return 1
    fi
    
    # Create a temp file with a unique name
    temp_file="${list_path}.tmp.$$"
    
    # Update the item at the specified index
    # We add 1 because sed uses 1-based indexing
    sed "$((index + 1))s/.*/${item}/" "${list_path}" > "${temp_file}" && 
    mv "${temp_file}" "${list_path}" || return 1
    
    return 0
}

# Insert an item at a specific index
arraylist_insert() {
    list_name="${1:-default}"
    index="$2"
    item="$3"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        arraylist_init "${list_name}" >/dev/null || return 1
    fi
    
    # Validate index
    if ! [ "${index}" -ge 0 ] 2>/dev/null; then
        return 1
    fi
    
    # Get the current size
    size=$(arraylist_size "${list_name}")
    
    # If the index is beyond the current size, just append the item
    if [ "${index}" -ge "${size}" ]; then
        arraylist_add "${list_name}" "${item}"
        return $?
    fi
    
    # Create a temp file with a unique name
    temp_file="${list_path}.tmp.$$"
    
    # Insert the item at the specified index
    # We add 1 because sed uses 1-based indexing
    sed "$((index + 1))i\\
${item}" "${list_path}" > "${temp_file}" &&
    mv "${temp_file}" "${list_path}" || return 1
    
    return 0
}

# Remove an item at a specific index
arraylist_remove() {
    list_name="${1:-default}"
    index="$2"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        return 1
    fi
    
    # Validate index
    if ! [ "${index}" -ge 0 ] 2>/dev/null; then
        return 1
    fi
    
    # Get the current size
    size=$(arraylist_size "${list_name}")
    
    # Check if index is out of bounds
    if [ "${index}" -ge "${size}" ]; then
        return 1
    fi
    
    # Get the item that will be removed
    removed_item=$(arraylist_get "${list_name}" "${index}")
    
    # Create a temp file with a unique name
    temp_file="${list_path}.tmp.$$"
    
    # Remove the item at the specified index
    # We add 1 because sed uses 1-based indexing
    sed "$((index + 1))d" "${list_path}" > "${temp_file}" &&
    mv "${temp_file}" "${list_path}" || return 1
    
    # Output the removed item
    printf '%s\n' "${removed_item}"
    return 0
}

# Get the size of the arraylist
arraylist_size() {
    list_name="${1:-default}"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        echo "0"
        return 0
    fi
    
    # Count the lines in the arraylist file and subtract 1 to get zero-based size
    size=$(wc -l < "${list_path}" | tr -d ' ')
    echo "$((size))"
    return 0
}

# Check if the arraylist is empty
arraylist_is_empty() {
    list_name="${1:-default}"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists or is empty
    if [ ! -f "${list_path}" ] || [ ! -s "${list_path}" ]; then
        return 0  # True (arraylist is empty)
    fi
    
    return 1  # False (arraylist is not empty)
}

# Check if the arraylist contains an item
arraylist_contains() {
    list_name="${1:-default}"
    item="$2"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        return 1  # False (arraylist doesn't exist)
    fi
    
    # Use grep to check if the item exists in the arraylist
    # -F: fixed strings, -x: exact match, -q: quiet mode
    grep -Fxq "${item}" "${list_path}"
    return $?  # Return grep's exit code (0 if found, 1 if not found)
}

# Get the index of an item in the arraylist
arraylist_index_of() {
    list_name="${1:-default}"
    item="$2"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        echo "-1"
        return 1
    fi
    
    # Use grep to find the index of the item
    # -F: fixed strings, -x: exact match, -n: line numbers
    index=$(grep -Fxn "${item}" "${list_path}" | head -n 1 | cut -d: -f1)
    
    if [ -z "${index}" ]; then
        echo "-1"  # Item not found
        return 1
    fi
    
    # Subtract 1 to get zero-based index
    echo "$((index - 1))"
    return 0
}

# Clear the arraylist
arraylist_clear() {
    list_name="${1:-default}"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        return 1
    fi
    
    # Clear the arraylist
    : > "${list_path}"
    return 0
}

# Delete the arraylist
arraylist_delete() {
    list_name="${1:-default}"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        return 1
    fi
    
    # Remove the arraylist file
    rm "${list_path}"
    return 0
}

# List all items in the arraylist (for debugging)
arraylist_list() {
    list_name="${1:-default}"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        return 1
    fi
    
    # Output all items in the arraylist
    cat "${list_path}"
    return 0
}

# List all available arraylists
arraylist_list_all() {
    # Check if arraylist directory exists
    if [ ! -d "${ARRAYLIST_DIR}" ]; then
        return 1
    fi
    
    # List all arraylist files
    ls -1 "${ARRAYLIST_DIR}" 2>/dev/null
    return 0
}

# Sort the arraylist (in ascending order)
arraylist_sort() {
    list_name="${1:-default}"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    
    # Check if the arraylist exists
    if [ ! -f "${list_path}" ]; then
        return 1
    fi
    
    # Create a temp file with a unique name
    temp_file="${list_path}.tmp.$$"
    
    # Sort the arraylist and save to a temporary file
    sort "${list_path}" > "${temp_file}" && 
    mv "${temp_file}" "${list_path}"
    
    return 0
}

# Fixed arraylist_filter function
arraylist_filter() {
    list_name="${1:-default}"
    pattern="$2"
    dest_name="${3:-${list_name}_filtered}"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    dest_path="${ARRAYLIST_DIR}/${dest_name}"
    
    # Check if the source arraylist exists
    if [ ! -f "${list_path}" ]; then
        return 1
    fi
    
    # Ensure the directory exists
    mkdir -p "${ARRAYLIST_DIR}" 2>/dev/null
    
    # Create a new empty destination file
    : > "${dest_path}"
    
    # Process each item line by line
    while IFS= read -r item || [ -n "$item" ]; do
        # Use case statement for pattern matching (more POSIX-compatible)
        case "${item}" in
            *"${pattern}"*)
                # Item matches the pattern, add to filtered list
                echo "${item}" >> "${dest_path}"
                ;;
        esac
    done < "${list_path}"
    
    return 0
}

# POSIX-compatible map function (no here-strings)
arraylist_map() {
    list_name="${1:-default}"
    command="$2"
    dest_name="${3:-${list_name}_mapped}"
    list_path="${ARRAYLIST_DIR}/${list_name}"
    dest_path="${ARRAYLIST_DIR}/${dest_name}"
    
    # Check if the source arraylist exists
    if [ ! -f "${list_path}" ]; then
        return 1
    fi
    
    # Ensure the directory exists
    mkdir -p "${ARRAYLIST_DIR}" 2>/dev/null
    
    # Create a new empty destination file
    : > "${dest_path}"
    
    # Process each item using echo and a pipe
    while IFS= read -r item || [ -n "$item" ]; do
        # Use echo to pipe the content to the command
        result=$(echo "${item}" | eval "${command}" 2>/dev/null) || result="${item}"
        echo "${result}" >> "${dest_path}"
    done < "${list_path}"
    
    return 0
}