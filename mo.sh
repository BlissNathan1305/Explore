#!/bin/bash

# Image size for 4K mobile
WIDTH=2160
HEIGHT=3840
COUNT=5

# Check for ImageMagick
if ! command -v magick &> /dev/null; then
    echo "ImageMagick (magick) is not installed. Please install it."
    exit 1
fi

# Output directory
mkdir -p geometric_wallpapers
cd geometric_wallpapers || exit

echo "🖼️ Generating $COUNT geometric wallpapers..."

for i in $(seq 1 $COUNT); do
    FILENAME="geo_wallpaper_$i.jpg"

    case $i in
        1)
            magick -size ${WIDTH}x${HEIGHT} xc:black -stroke "#00FFFF" -fill none -draw "circle $((WIDTH/2)),$((HEIGHT/2)) $((WIDTH/2)),300" \
            -quality 100 "$FILENAME"
            ;;
        2)
            magick -size ${WIDTH}x${HEIGHT} xc:white -fill "#3333FF" -draw "path 'M 0,0 L $WIDTH,0 L $WIDTH,$HEIGHT L 0,$HEIGHT Z'" \
            -draw "line 0,0 $WIDTH,$HEIGHT" -draw "line $WIDTH,0 0,$HEIGHT" \
            -quality 100 "$FILENAME"
            ;;
        3)
            magick -size ${WIDTH}x${HEIGHT} pattern:checkerboard -colorspace sRGB -resize ${WIDTH}x${HEIGHT}! \
            -quality 100 "$FILENAME"
            ;;
        4)
            magick -size ${WIDTH}x${HEIGHT} gradient:"#ff7e5f"-"#feb47b" -gravity center \
            -font DejaVu-Sans-Bold -pointsize 120 -fill white -annotate 0 'Geometric Vibe' \
            -quality 100 "$FILENAME"
            ;;
        5)
            magick -size ${WIDTH}x${HEIGHT} xc:black -fill none -stroke "#FFD700" -strokewidth 5 \
            -draw "polygon 1080,0 2160,1920 1080,3840 0,1920" \
            -quality 100 "$FILENAME"
            ;;
    esac

    echo "✅ Created $FILENAME"
done

echo "🎉 All wallpapers generated in ./geometric_wallpapers"
