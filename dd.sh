#!/data/data/com.termux/files/usr/bin/bash

# Get current month and year
MONTH=$(date +%m)
YEAR=$(date +%Y)

# Output files
TEXT_FILE="calendar.txt"
JPEG_FILE="calendar.jpg"
FONT_PATH="/data/data/com.termux/files/usr/share/fonts/TTF/DejaVuSansMono.ttf"

# Generate calendar and save to text
cal $MONTH $YEAR > $TEXT_FILE

# Convert the calendar text to a JPEG image
magick -background lightyellow -fill black \
       -font "$FONT_PATH" -pointsize 24 \
       label:@"$TEXT_FILE" "$JPEG_FILE"

# Clean up text file
rm "$TEXT_FILE"

echo "✅ Calendar saved as $JPEG_FILE"
