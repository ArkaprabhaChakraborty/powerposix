#!/bin/sh
# stack.sh - A POSIX-compliant stack implementation
# Usage: . ./stack.sh

# Default location for the stack files
STACK_DIR="${STACK_DIR:-/tmp/stack}"

# Initialize the stack
stack_init() {
    stack_name="${1:-default}"
    stack_path="${STACK_DIR}/${stack_name}"
    
    # Create stack directory if it doesn't exist
    mkdir -p "${STACK_DIR}" 2>/dev/null || return 1
    
    # Initialize or clear the stack file
    : > "${stack_path}" || return 1
    
    # Set permissions to be readable/writable only by the owner
    chmod 600 "${stack_path}" 2>/dev/null
    
    echo "${stack_path}"
}

# Push an item onto the stack
stack_push() {
    stack_name="${1:-default}"
    item="$2"
    stack_path="${STACK_DIR}/${stack_name}"
    
    # Check if the stack exists
    if [ ! -f "${stack_path}" ]; then
        stack_init "${stack_name}" >/dev/null || return 1
    fi
    
    # Add the item to the top of the stack
    # We use a temporary file to avoid race conditions
    printf '%s\n' "${item}" > "${stack_path}.tmp" || return 1
    cat "${stack_path}" >> "${stack_path}.tmp" || return 1
    mv "${stack_path}.tmp" "${stack_path}" || return 1
    
    return 0
}

# Pop an item from the stack
stack_pop() {
    stack_name="${1:-default}"
    stack_path="${STACK_DIR}/${stack_name}"
    
    # Check if the stack exists
    if [ ! -f "${stack_path}" ]; then
        return 1
    fi
    
    # Check if the stack is empty
    if [ ! -s "${stack_path}" ]; then
        return 1
    fi
    
    # Get the top item
    item=$(head -n 1 "${stack_path}")
    
    # Remove the top item from the stack
    tail -n +2 "${stack_path}" > "${stack_path}.tmp" || return 1
    mv "${stack_path}.tmp" "${stack_path}" || return 1
    
    # Output the popped item
    printf '%s\n' "${item}"
    return 0
}

# Peek at the top item without removing it
stack_peek() {
    stack_name="${1:-default}"
    stack_path="${STACK_DIR}/${stack_name}"
    
    # Check if the stack exists
    if [ ! -f "${stack_path}" ]; then
        return 1
    fi
    
    # Check if the stack is empty
    if [ ! -s "${stack_path}" ]; then
        return 1
    fi
    
    # Get the top item
    head -n 1 "${stack_path}"
    return 0
}

# Get the size of the stack
stack_size() {
    stack_name="${1:-default}"
    stack_path="${STACK_DIR}/${stack_name}"
    
    # Check if the stack exists
    if [ ! -f "${stack_path}" ]; then
        echo "0"
        return 0
    fi
    
    # Count the lines in the stack file
    wc -l < "${stack_path}" | tr -d ' '
    return 0
}

# Check if the stack is empty
stack_is_empty() {
    stack_name="${1:-default}"
    stack_path="${STACK_DIR}/${stack_name}"
    
    # Check if the stack exists or is empty
    if [ ! -f "${stack_path}" ] || [ ! -s "${stack_path}" ]; then
        return 0  # True (stack is empty)
    fi
    
    return 1  # False (stack is not empty)
}

# Clear the stack
stack_clear() {
    stack_name="${1:-default}"
    stack_path="${STACK_DIR}/${stack_name}"
    
    # Check if the stack exists
    if [ ! -f "${stack_path}" ]; then
        return 1
    fi
    
    # Clear the stack
    : > "${stack_path}"
    return 0
}

# Delete the stack
stack_delete() {
    stack_name="${1:-default}"
    stack_path="${STACK_DIR}/${stack_name}"
    
    # Check if the stack exists
    if [ ! -f "${stack_path}" ]; then
        return 1
    fi
    
    # Remove the stack file
    rm "${stack_path}"
    return 0
}

# List all stack items (for debugging)
stack_list() {
    stack_name="${1:-default}"
    stack_path="${STACK_DIR}/${stack_name}"
    
    # Check if the stack exists
    if [ ! -f "${stack_path}" ]; then
        return 1
    fi
    
    # Output all items in the stack
    cat "${stack_path}"
    return 0
}

# List all available stacks
stack_list_all() {
    # Check if stack directory exists
    if [ ! -d "${STACK_DIR}" ]; then
        return 1
    fi
    
    # List all stack files
    ls -1 "${STACK_DIR}" 2>/dev/null
    return 0
}