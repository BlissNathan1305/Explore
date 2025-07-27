#!/data/data/com.termux/files/usr/bin/bash

# Get current month and year
MONTH=$(date +%m)
YEAR=$(date +%Y)

# Output files
TEXT_FILE="calendar.txt"
JPEG_FILE="calendar.jpg"

# Generate calendar
cal $MONTH $YEAR > $TEXT_FILE

# Convert text to image
convert -background white -fill black \
        -font Courier -pointsize 24 \
        label:@"$TEXT_FILE" "$JPEG_FILE"

# Clean up
rm "$TEXT_FILE"

echo "✅ Calendar saved as $JPEG_FILE"
