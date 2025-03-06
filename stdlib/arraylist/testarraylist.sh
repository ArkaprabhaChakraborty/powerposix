#!/bin/sh
# example_arraylist.sh - Example usage of the arraylist library

# Import the arraylist library
. ./arraylist.sh

# Create a new arraylist
arraylist_init "mylist"

# Add some items
arraylist_add "mylist" "Apple"
arraylist_add "mylist" "Banana"
arraylist_add "mylist" "Cherry"

# Show the list size
echo "ArrayList size: $(arraylist_size "mylist")"

# Access elements by index
echo "Item at index 1: $(arraylist_get "mylist" 1)"

# Update an element
arraylist_set "mylist" 1 "Blueberry"
echo "Updated item at index 1: $(arraylist_get "mylist" 1)"

# Insert an element
arraylist_insert "mylist" 1 "Blackberry"
echo "After insertion:"
arraylist_list "mylist"

# Remove an element
removed=$(arraylist_remove "mylist" 2)
echo "Removed: $removed"
echo "After removal:"
arraylist_list "mylist"

# Check if the list contains an item
if arraylist_contains "mylist" "Apple"; then
    echo "The list contains Apple"
else
    echo "The list does not contain Apple"
fi

# Find the index of an item
echo "Index of Cherry: $(arraylist_index_of "mylist" "Cherry")"

# Sort the arraylist
arraylist_sort "mylist"
echo "After sorting:"
arraylist_list "mylist"

# Filter items
arraylist_filter "mylist" "berry" "filtered_list"
echo "Filtered items (containing 'berry'):"
arraylist_list "filtered_list"

# Map operation - convert to uppercase
arraylist_map "mylist" "tr '[:lower:]' '[:upper:]'" "uppercase_list"
echo "Uppercase items:"
arraylist_list "uppercase_list"

# Clean up
arraylist_delete "mylist"
arraylist_delete "filtered_list"
arraylist_delete "uppercase_list"