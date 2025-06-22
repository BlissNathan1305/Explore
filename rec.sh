#!/bin/bash

# Function to print recursion
print_recursion() {
  local count=$1
  if [ "$count" -le 0 ]; then
    return
  fi
  echo "Recursion level: $count"
  print_recursion $((count - 1))
}

# Call the function with an initial count
print_recursion 5

