#!/bin/sh
# queue.sh - A POSIX-compliant queue implementation
# Usage: . ./queue.sh

# Default location for the queue files
QUEUE_DIR="${QUEUE_DIR:-/tmp/queue}"

# Initialize the queue
queue_init() {
    queue_name="${1:-default}"
    queue_path="${QUEUE_DIR}/${queue_name}"
    
    # Create queue directory if it doesn't exist
    mkdir -p "${QUEUE_DIR}" 2>/dev/null || return 1
    
    # Initialize or clear the queue file
    : > "${queue_path}" || return 1
    
    # Set permissions to be readable/writable only by the owner
    chmod 600 "${queue_path}" 2>/dev/null
    
    echo "${queue_path}"
}

# Enqueue an item to the queue (add to end)
queue_enqueue() {
    queue_name="${1:-default}"
    item="$2"
    queue_path="${QUEUE_DIR}/${queue_name}"
    
    # Check if the queue exists
    if [ ! -f "${queue_path}" ]; then
        queue_init "${queue_name}" >/dev/null || return 1
    fi
    
    # Add the item to the end of the queue
    printf '%s\n' "${item}" >> "${queue_path}" || return 1
    
    return 0
}

# Dequeue an item from the queue (remove from front)
queue_dequeue() {
    queue_name="${1:-default}"
    queue_path="${QUEUE_DIR}/${queue_name}"
    
    # Check if the queue exists
    if [ ! -f "${queue_path}" ]; then
        return 1
    fi
    
    # Check if the queue is empty
    if [ ! -s "${queue_path}" ]; then
        return 1
    fi
    
    # Get the front item
    item=$(head -n 1 "${queue_path}")
    
    # Remove the front item from the queue
    tail -n +2 "${queue_path}" > "${queue_path}.tmp" || return 1
    mv "${queue_path}.tmp" "${queue_path}" || return 1
    
    # Output the dequeued item
    printf '%s\n' "${item}"
    return 0
}

# Peek at the front item without removing it
queue_peek() {
    queue_name="${1:-default}"
    queue_path="${QUEUE_DIR}/${queue_name}"
    
    # Check if the queue exists
    if [ ! -f "${queue_path}" ]; then
        return 1
    fi
    
    # Check if the queue is empty
    if [ ! -s "${queue_path}" ]; then
        return 1
    fi
    
    # Get the front item
    head -n 1 "${queue_path}"
    return 0
}

# Get the size of the queue
queue_size() {
    queue_name="${1:-default}"
    queue_path="${QUEUE_DIR}/${queue_name}"
    
    # Check if the queue exists
    if [ ! -f "${queue_path}" ]; then
        echo "0"
        return 0
    fi
    
    # Count the lines in the queue file
    wc -l < "${queue_path}" | tr -d ' '
    return 0
}

# Check if the queue is empty
queue_is_empty() {
    queue_name="${1:-default}"
    queue_path="${QUEUE_DIR}/${queue_name}"
    
    # Check if the queue exists or is empty
    if [ ! -f "${queue_path}" ] || [ ! -s "${queue_path}" ]; then
        return 0  # True (queue is empty)
    fi
    
    return 1  # False (queue is not empty)
}

# Clear the queue
queue_clear() {
    queue_name="${1:-default}"
    queue_path="${QUEUE_DIR}/${queue_name}"
    
    # Check if the queue exists
    if [ ! -f "${queue_path}" ]; then
        return 1
    fi
    
    # Clear the queue
    : > "${queue_path}"
    return 0
}

# Delete the queue
queue_delete() {
    queue_name="${1:-default}"
    queue_path="${QUEUE_DIR}/${queue_name}"
    
    # Check if the queue exists
    if [ ! -f "${queue_path}" ]; then
        return 1
    fi
    
    # Remove the queue file
    rm "${queue_path}"
    return 0
}

# List all queue items (for debugging)
queue_list() {
    queue_name="${1:-default}"
    queue_path="${QUEUE_DIR}/${queue_name}"
    
    # Check if the queue exists
    if [ ! -f "${queue_path}" ]; then
        return 1
    fi
    
    # Output all items in the queue
    cat "${queue_path}"
    return 0
}

# List all available queues
queue_list_all() {
    # Check if queue directory exists
    if [ ! -d "${QUEUE_DIR}" ]; then
        return 1
    fi
    
    # List all queue files
    ls -1 "${QUEUE_DIR}" 2>/dev/null
    return 0
}