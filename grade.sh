#!/bin/bash

# Ask the user for a score
read -p "Enter your score (0-100): " score

# Validate the input
if ! [[ $score =~ ^[0-9]+$ ]] || (( score < 0 || score > 100 )); then
  echo "Invalid score. Please enter a number between 0 and 100."
  exit 1
fi

# Determine the grade
if (( score >= 90 )); then
  grade="A"
elif (( score >= 80 )); then
  grade="B"
elif (( score >= 70 )); then
  grade="C"
elif (( score >= 60 )); then
  grade="D"
else
  grade="F"
fi

# Output the result
echo "Your grade is: $grade"

