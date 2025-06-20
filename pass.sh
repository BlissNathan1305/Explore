#!/bin/bash

# Set the correct password
CORRECT_PASSWORD="mysecretpassword"

# Function to authenticate password
authenticate_password() {
  read -s -p "Enter password: " input_password
  echo
  if [ "$input_password" == "$CORRECT_PASSWORD" ]; then
    echo "Authentication successful!"
    return 0
  else
    echo "Authentication failed!"
    return 1
  fi
}

# Call the function
if authenticate_password; then
  echo "Access granted!"
else
  echo "Access denied!"
fi

