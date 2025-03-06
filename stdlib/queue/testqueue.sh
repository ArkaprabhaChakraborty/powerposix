#!/bin/sh
# example_queue.sh - Example usage of the queue library

# Import the queue library
. ./queue.sh

# Create a new queue
queue_init "myqueue"

# Enqueue some items
queue_enqueue "myqueue" "First item"
queue_enqueue "myqueue" "Second item"
queue_enqueue "myqueue" "Third item"

# Show the queue size
echo "Queue size: $(queue_size "myqueue")"

# Peek at the front item
echo "Front item: $(queue_peek "myqueue")"

# Dequeue items from the queue
echo "Dequeued: $(queue_dequeue "myqueue")"
echo "Dequeued: $(queue_dequeue "myqueue")"

# Check the new size
echo "New queue size: $(queue_size "myqueue")"

# List all items in the queue
echo "Queue contents:"
queue_list "myqueue"

# Clear the queue
queue_clear "myqueue"
echo "After clearing, queue is empty: $(queue_is_empty "myqueue" && echo "Yes" || echo "No")"

# Working with multiple queues
queue_init "queue1"
queue_init "queue2"

queue_enqueue "queue1" "Queue 1 item"
queue_enqueue "queue2" "Queue 2 item"

echo "Available queues:"
queue_list_all

# Clean up
queue_delete "myqueue"
queue_delete "queue1"
queue_delete "queue2"