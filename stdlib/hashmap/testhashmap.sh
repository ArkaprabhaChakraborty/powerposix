. ./hashmap.sh

# Initialize a hashmap named "user_data"
hashmap_init "user_data"

# Set values
hashmap_set "user_data" "john_doe" "42|john@example.com|USA"
hashmap_set "user_data" "jane_smith" "35|jane@example.com|UK"

# Get values
john_data=$(hashmap_get "user_data" "john_doe")
echo "John's data: $john_data"

# Check existence
if hashmap_has "user_data" "john_doe"; then
    echo "John exists in the system"
fi

# List all keys
echo "All users:"
hashmap_keys "user_data"

# Count entries
echo "Total users: $(hashmap_count "user_data")"

# Delete entry
hashmap_del "user_data" "john_doe"
# Count entries
echo "Total users after deletion: $(hashmap_count "user_data")"


echo "All users:"
hashmap_keys "user_data"

# Cleanup when done
hashmap_destroy "user_data"