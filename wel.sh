#!/bin/bash

# Wallpaper resolution (4K for mobile)
WIDTH=2160
HEIGHT=3840
OUTPUT="mobile_wallpaper_4k.jpg"

# Colors and gradient
COLOR1="#1e3c72"  # Dark blue
COLOR2="#2a5298"  # Light blue

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null; then
    echo "ImageMagick (magick) not found. Please install it first."
    exit 1
fi

# Create a vertical gradient background and overlay text
magick -size ${WIDTH}x${HEIGHT} gradient:"$COLOR1"-"$COLOR2" \
    -gravity center \
    -font DejaVu-Sans-Bold \
    -pointsize 160 \
    -fill white \
    -annotate +0+0 'Inspire Today ✨' \
    -quality 100 \
    "$OUTPUT"

echo "✅ Wallpaper generated: $OUTPUT"
