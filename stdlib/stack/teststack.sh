#!/bin/sh
# example.sh - Example usage of the stack library

# Import the stack library
. ./stack.sh

# Create a new stack
stack_init "mystack"

# Push some items
stack_push "mystack" "First item"
stack_push "mystack" "Second item"
stack_push "mystack" "Third item"

# Show the stack size
echo "Stack size: $(stack_size "mystack")"

# Peek at the top item
echo "Top item: $(stack_peek "mystack")"

# Pop items from the stack
echo "Popped: $(stack_pop "mystack")"
echo "Popped: $(stack_pop "mystack")"

# Check the new size
echo "New stack size: $(stack_size "mystack")"

# List all items in the stack
echo "Stack contents:"
stack_list "mystack"

# Clear the stack
stack_clear "mystack"
echo "After clearing, stack is empty: $(stack_is_empty "mystack" && echo "Yes" || echo "No")"

# Working with multiple stacks
stack_init "stack1"
stack_init "stack2"

stack_push "stack1" "Stack 1 item"
stack_push "stack2" "Stack 2 item"

echo "Available stacks:"
stack_list_all

# Clean up
stack_delete "mystack"
stack_delete "stack1"
stack_delete "stack2"