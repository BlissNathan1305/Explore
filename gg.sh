#!/bin/bash

# JPEG Calendar Generator Script
# Requires ImageMagick to be installed
# Usage: ./calendar_jpeg.sh [month] [year] [output_file]

# Check if ImageMagick is installed
check_imagemagick() {
    if ! command -v convert &> /dev/null; then
        echo "Error: ImageMagick is not installed."
        echo "Please install ImageMagick:"
        echo "  Ubuntu/Debian: sudo apt-get install imagemagick"
        echo "  CentOS/RHEL: sudo yum install ImageMagick"
        echo "  macOS: brew install imagemagick"
        exit 1
    fi
}

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

# Function to generate calendar JPEG
generate_calendar_jpeg() {
    local month=$1
    local year=$2
    local output_file=$3
    
    local month_name=$(get_month_name $month)
    local days=$(days_in_month $month $year)
    local first_day=$(get_first_day_of_week $month $year)
    
    # Image dimensions and settings
    local width=800
    local height=600
    local cell_width=$((width / 7))
    local cell_height=$((height / 8))
    local header_height=$((cell_height * 2))
    
    # Colors
    local bg_color="#f0f0f0"
    local header_bg="#4a90e2"
    local text_color="#333333"
    local header_text="#ffffff"
    local grid_color="#cccccc"
    local today_color="#ff6b6b"
    
    # Get current date for highlighting
    local current_day=$(date +%-d)
    local current_month=$(date +%-m)
    local current_year=$(date +%Y)
    
    # Start building ImageMagick command
    local cmd="convert -size ${width}x${height} xc:\"$bg_color\""
    
    # Draw header background
    cmd="$cmd -fill \"$header_bg\" -draw \"rectangle 0,0 $width,$header_height\""
    
    # Draw month and year title
    cmd="$cmd -fill \"$header_text\" -font DejaVu-Sans-Bold -pointsize 36 -gravity North"
    cmd="$cmd -annotate +0+20 \"$month_name $year\""
    
    # Draw day headers
    local day_names=("Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat")
    local y_day_header=$((header_height - 40))
    
    for i in {0..6}; do
        local x_center=$(( (i * cell_width) + (cell_width / 2) ))
        cmd="$cmd -fill \"$header_text\" -font DejaVu-Sans-Bold -pointsize 16"
        cmd="$cmd -annotate +$x_center+$y_day_header \"${day_names[$i]}\""
    done
    
    # Draw grid lines
    cmd="$cmd -stroke \"$grid_color\" -strokewidth 1"
    
    # Vertical lines
    for (( i=0; i<=7; i++ )); do
        local x=$((i * cell_width))
        cmd="$cmd -draw \"line $x,$header_height $x,$height\""
    done
    
    # Horizontal lines
    for (( i=0; i<=6; i++ )); do
        local y=$((header_height + (i * cell_height)))
        cmd="$cmd -draw \"line 0,$y $width,$y\""
    done
    
    # Draw calendar days
    local day_of_week=$first_day
    local week=0
    
    for (( day=1; day<=days; day++ )); do
        local x_center=$(( (day_of_week * cell_width) + (cell_width / 2) ))
        local y_center=$(( header_height + (week * cell_height) + (cell_height / 2) ))
        
        # Check if this is today
        local is_today=false
        if [[ $day -eq $current_day && $month -eq $current_month && $year -eq $current_year ]]; then
            is_today=true
        fi
        
        # Draw background circle for today
        if [[ $is_today == true ]]; then
            local circle_radius=20
            cmd="$cmd -stroke \"$today_color\" -strokewidth 3 -fill none"
            cmd="$cmd -draw \"circle $x_center,$y_center $((x_center + circle_radius)),$y_center\""
        fi
        
        # Draw day number
        local day_color="$text_color"
        if [[ $is_today == true ]]; then
            day_color="$today_color"
        fi
        
        cmd="$cmd -fill \"$day_color\" -font DejaVu-Sans-Bold -pointsize 18"
        cmd="$cmd -annotate +$x_center+$y_center \"$day\""
        
        day_of_week=$(( (day_of_week + 1) % 7 ))
        
        # Move to next week after Saturday
        if (( day_of_week == 0 )); then
            week=$((week + 1))
        fi
    done
    
    # Add subtle shadow effect
    cmd="$cmd -stroke none"
    
    # Final output
    cmd="$cmd \"$output_file\""
    
    # Execute the command
    eval $cmd
    
    if [[ $? -eq 0 ]]; then
        echo "Calendar saved as: $output_file"
        echo "Dimensions: ${width}x${height} pixels"
        if command -v identify &> /dev/null; then
            echo "File info: $(identify "$output_file")"
        fi
    else
        echo "Error: Failed to generate calendar image"
        exit 1
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [month] [year] [output_file]"
    echo
    echo "Arguments:"
    echo "  month       : Month number (1-12), optional (default: current month)"
    echo "  year        : Year (4 digits), optional (default: current year)"
    echo "  output_file : Output JPEG filename, optional (default: calendar_YYYY_MM.jpg)"
    echo
    echo "Examples:"
    echo "  $0                           # Current month, auto-named file"
    echo "  $0 12                        # December current year, auto-named file"
    echo "  $0 12 2024                   # December 2024, auto-named file"
    echo "  $0 12 2024 xmas_cal.jpg      # December 2024, custom filename"
    echo
    echo "Requirements:"
    echo "  - ImageMagick must be installed"
    echo "  - DejaVu Sans font (usually pre-installed on most systems)"
}

# Main script logic
main() {
    # Check prerequisites
    check_imagemagick
    
    local current_month=$(date +%-m)
    local current_year=$(date +%Y)
    local month=$current_month
    local year=$current_year
    local output_file=""
    
    # Parse arguments
    case $# in
        0)
            # Use defaults
            ;;
        1)
            if [[ "$1" == "-h" || "$1" == "--help" ]]; then
                show_usage
                exit 0
            elif (( $1 >= 1000 )); then
                # Year only
                year=$1
            elif (( $1 >= 1 && $1 <= 12 )); then
                # Month only
                month=$1
            else
                echo "Error: Invalid argument. Use -h for help."
                exit 1
            fi
            ;;
        2)
            month=$1
            year=$2
            ;;
        3)
            month=$1
            year=$2
            output_file=$3
            ;;
        *)
            echo "Error: Too many arguments. Use -h for help."
            exit 1
            ;;
    esac
    
    # Validate inputs
    if (( month < 1 || month > 12 )); then
        echo "Error: Invalid month ($month). Month must be between 1 and 12."
        exit 1
    fi
    
    if (( year < 1 || year > 9999 )); then
        echo "Error: Invalid year ($year). Year must be between 1 and 9999."
        exit 1
    fi
    
    # Generate default filename if not provided
    if [[ -z "$output_file" ]]; then
        output_file=$(printf "calendar_%04d_%02d.jpg" "$year" "$month")
    fi
    
    # Ensure output file has .jpg extension
    if [[ ! "$output_file" =~ \.(jpg|jpeg|JPG|JPEG)$ ]]; then
        output_file="${output_file}.jpg"
    fi
    
    echo "Generating calendar for $(get_month_name $month) $year..."
    generate_calendar_jpeg $month $year "$output_file"
}

# Run the script
main "$@"
