#!/bin/bash

# Calendar Generator Script
# Usage: ./calendar.sh [month] [year]
# If no arguments provided, shows current month
# If only year provided, shows entire year

# Function to check if a year is a leap year
is_leap_year() {
    local year=$1
    if (( year % 400 == 0 )); then
        return 0
    elif (( year % 100 == 0 )); then
        return 1
    elif (( year % 4 == 0 )); then
        return 0
    else
        return 1
    fi
}

# Function to get days in a month
days_in_month() {
    local month=$1
    local year=$2
    
    case $month in
        1|3|5|7|8|10|12) echo 31 ;;
        4|6|9|11) echo 30 ;;
        2) 
            if is_leap_year $year; then
                echo 29
            else
                echo 28
            fi
            ;;
    esac
}

# Function to get the day of week for the first day of month
# Uses Zeller's congruence algorithm
get_first_day_of_week() {
    local month=$1
    local year=$2
    
    # Adjust month and year for Zeller's formula
    if (( month < 3 )); then
        month=$((month + 12))
        year=$((year - 1))
    fi
    
    local k=$((year % 100))
    local j=$((year / 100))
    
    local h=$(( (1 + ((13 * (month + 1)) / 5) + k + (k / 4) + (j / 4) - 2 * j) % 7 ))
    
    # Convert to Sunday=0 format
    echo $(( (h + 5) % 7 ))
}

# Function to get month name
get_month_name() {
    local month=$1
    local months=("" "January" "February" "March" "April" "May" "June" 
                  "July" "August" "September" "October" "November" "December")
    echo "${months[$month]}"
}

# Function to print a single month calendar
print_month() {
    local month=$1
    local year=$2
    
    local month_name=$(get_month_name $month)
    local days=$(days_in_month $month $year)
    local first_day=$(get_first_day_of_week $month $year)
    
    # Print header
    printf "\n%20s %d\n" "$month_name" "$year"
    echo "Su Mo Tu We Th Fr Sa"
    echo "-------------------"
    
    # Print leading spaces
    for (( i=0; i<first_day; i++ )); do
        printf "   "
    done
    
    # Print days
    local day_of_week=$first_day
    for (( day=1; day<=days; day++ )); do
        printf "%2d " "$day"
        day_of_week=$(( (day_of_week + 1) % 7 ))
        
        # New line after Saturday
        if (( day_of_week == 0 )); then
            echo
        fi
    done
    
    # Add final newline if month doesn't end on Saturday
    if (( day_of_week != 0 )); then
        echo
    fi
    echo
}

# Function to print entire year calendar
print_year() {
    local year=$1
    
    echo
    printf "%32s\n" "$year"
    echo "=================================================="
    
    for month in {1..12}; do
        print_month $month $year
    done
}

# Main script logic
main() {
    local current_month=$(date +%-m)
    local current_year=$(date +%Y)
    
    if (( $# == 0 )); then
        # No arguments - show current month
        print_month $current_month $current_year
    elif (( $# == 1 )); then
        # One argument - could be month or year
        if (( $1 >= 1000 )); then
            # Assume it's a year
            print_year $1
        elif (( $1 >= 1 && $1 <= 12 )); then
            # Assume it's a month for current year
            print_month $1 $current_year
        else
            echo "Error: Invalid month ($1). Month must be between 1 and 12."
            exit 1
        fi
    elif (( $# == 2 )); then
        # Two arguments - month and year
        local month=$1
        local year=$2
        
        if (( month < 1 || month > 12 )); then
            echo "Error: Invalid month ($month). Month must be between 1 and 12."
            exit 1
        fi
        
        if (( year < 1 )); then
            echo "Error: Invalid year ($year). Year must be positive."
            exit 1
        fi
        
        print_month $month $year
    else
        echo "Usage: $0 [month] [year]"
        echo "  No arguments: Show current month"
        echo "  One argument: Show specific month (current year) or entire year"
        echo "  Two arguments: Show specific month and year"
        echo
        echo "Examples:"
        echo "  $0              # Current month"
        echo "  $0 12           # December of current year"
        echo "  $0 2024         # Entire year 2024"
        echo "  $0 12 2024      # December 2024"
        exit 1
    fi
}

# Run the script
main "$@"
