#!/bin/bash

# Prompt the user to enter the project name
read -p "Enter the project name: " project_name

# Create a new directory with the project name
mkdir "$project_name"

# Check if the directory was created successfully
if [ $? -eq 0 ]; then
    echo "Directory '$project_name' created successfully."
else
    echo "Failed to create directory '$project_name'."
    exit 1
fi

# Navigate into the new directory
cd "$project_name"

# Initialize a new Git repository
git init

# Check if Git initialization was successful
if [ $? -eq 0 ]; then
    echo "Git repository initialized successfully."
else
    echo "Failed to initialize Git repository."
    exit 1
fi

# Create a README.md file
echo "# $project_name" > README.md

# Check if the README.md file was created successfully
if [ $? -eq 0 ]; then
    echo "README.md file created successfully."
else
    echo "Failed to create README.md file."
    exit 1
fi

# Add all files to the Git repository and commit
git add .
git commit -m "Initial commit"

# Check if the commit was successful
if [ $? -eq 0 ]; then
    echo "Initial commit completed successfully."
else
    echo "Failed to complete initial commit."
    exit 1
fi

echo "Project '$project_name' is ready!"
