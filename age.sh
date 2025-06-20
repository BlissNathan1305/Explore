#!/bin/bash

# Get birthdate from user
read -p "Enter your birth year (YYYY): " birth_year
read -p "Enter your birth month (MM): " birth_month
read -p "Enter your birth day (DD): " birth_day

# Get current date
current_year=$(date +"%Y")
current_month=$(date +"%m")
current_day=$(date +"%d")

# Calculate age
if (( current_month > birth_month || (current_month == birth_month && current_day >= birth_day) )); then
  age=$((current_year - birth_year))
else
  age=$((current_year - birth_year - 1))
fi

# Print age
echo "Your age is: $age"

