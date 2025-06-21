#!/bin/bash

# Function to generate a random letter (uppercase or lowercase)
generate_random_letter() {
    # Generate a random number between 0 and 51
    local random_number=$((RANDOM % 52))

    # Determine if it's uppercase (0-25) or lowercase (26-51)
    if [ $random_number -lt 26 ]; then
        # Generate uppercase letter (ASCII 65-90)
        printf "\\$(printf '%03o' $((65 + random_number)))"
    else
        # Generate lowercase letter (ASCII 97-122)
        printf "\\$(printf '%03o' $((97 + (random_number - 26))))"
    fi
}

# Check if the user provided a number as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <number_of_letters>"
    exit 1
fi

# Validate the input to ensure it's a positive integer
if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Error: Argument must be a positive integer."
    exit 1
fi

# Extract the number of letters to generate
number_of_letters=$1

# Generate the random letters
random_letters=""
for ((i=0; i<number_of_letters; i++)); do
    random_letters+="$(generate_random_letter)"
done

# Output the result
echo "Generated random letters: $random_letters"
