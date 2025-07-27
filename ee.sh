#!/bin/bash
# wallpaper_generator.sh

# This script generates stunning abstract wallpapers for mobile devices
# using ImageMagick. It creates 4K (2160x3840 portrait) JPEG images.

# Usage:
#   ./wallpaper_generator.sh [number_of_wallpapers]

##############################################################################
#                                Configuration                               #
##############################################################################

# --- Image Dimensions for 4K Mobile (Portrait) ---
# Common 4K mobile resolutions are around 2160x3840 or 1440x2560 scaled up.
# We'll use 2160x3840 for true 4K portrait.
WIDTH=2160
HEIGHT=3840

# --- Output Settings ---
OUTPUT_DIR="generated_wallpapers"
JPEG_QUALITY=90 # JPEG quality (0-100, 100 is best, larger file size)

# --- Number of Wallpapers to Generate ---
# Default to 5 if no argument is provided
NUM_WALLPAPERS=${1:-5}

# --- Color Palettes ---
# A diverse set of colors to choose from for gradients and effects
declare -a COLORS=(
    "#FF6B6B" "#4ECDC4" "#45B7D1" "#FFA07A" "#98D8AA" "#C7A2E0" "#FFD700" "#87CEEB"
    "#FFB6C1" "#90EE90" "#ADD8E6" "#FFDEAD" "#F08080" "#20B2AA" "#8A2BE2" "#FF4500"
    "#6A5ACD" "#3CB371" "#FFC0CB" "#6495ED" "#DAA520" "#BA55D3" "#7B68EE" "#00CED1"
    "#FF7F50" "#5F9EA0" "#DC143C" "#00BFFF" "#ADFF2F" "#FF6347" "#4682B4" "#DDA0DD"
    "#F0E68C" "#9ACD32" "#87CEFA" "#FFEFD5" "#CD5C5C" "#66CDAA" "#9370DB" "#F4A460"
    "#B0C4DE" "#8B0000" "#00FF7F" "#483D8B" "#FFDAB9" "#778899" "#800080" "#FF8C00"
    "#2F4F4F" "#9932CC" "#BDB76B" "#8B4513" "#D2B48C" "#A9A9A9" "#556B2F" "#C0C0C0"
)

# --- Error Handling & Script Robustness ---
set -euo pipefail # Exit on error, exit on unset variables, exit if command in pipe fails

##############################################################################
#                                  Functions                                 #
##############################################################################

# Function to log messages with colors
log() {
    local LEVEL="$1" # INFO, SUCCESS, ERROR, WARNING
    local MESSAGE="$2"
    local COLOR_NC='\033[0m' # No Color

    case "$LEVEL" in
        INFO)    local COLOR='\033[0;34m' ;; # Blue
        SUCCESS) local COLOR='\033[0;32m' ;; # Green
        ERROR)   local COLOR='\033[0;31m' ;; # Red
        WARNING) local COLOR='\033[0;33m' ;; # Yellow
        *)       local COLOR='\033[0m' ;;    # Default to no color
    esac
    echo -e "${COLOR}[$LEVEL]${COLOR_NC} $MESSAGE" >&2 # Output to stderr for logs
}

# Function to get a random color from the COLORS array
get_random_color() {
    echo "${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
}

# Function to get multiple unique random colors
get_n_random_colors() {
    local N=$1
    # Use shuf to get N unique random colors from the array, joined by space
    shuf -n "$N" -e "${COLORS[@]}" | tr '\n' ' '
}

# --- Wallpaper Generation Methods ---

# 1. Gradient Plasma with Swirl
generate_gradient_swirl() {
    local OUTPUT_FILE="$1"
    local COLOR1=$(get_random_color)
    local COLOR2=$(get_random_color)
    local SWIRL_ANGLE=$((RANDOM % 360 - 180)) # -180 to 180
    local BLUR_RADIUS=$((RANDOM % 5 + 1)) # 1 to 5

    log INFO "Generating Gradient Plasma with Swirl: $OUTPUT_FILE"
    magick -size "${WIDTH}x${HEIGHT}" \
        gradient:"$COLOR1"-"$COLOR2" \
        -wave "$((RANDOM % 20 + 5))x$((RANDOM % 10 + 2))" \
        -swirl "$SWIRL_ANGLE" \
        -blur 0x"$BLUR_RADIUS" \
        -quality "$JPEG_QUALITY" \
        "$OUTPUT_FILE"
}

# 2. Plasma Noise Abstract
generate_plasma_noise() {
    local OUTPUT_FILE="$1"
    local COLOR1=$(get_random_color)
    local COLOR2=$(get_random_color)
    local ROUGHNESS=$((RANDOM % 100 + 1)) # 1 to 100
    local SEED=$RANDOM # Random seed for plasma

    log INFO "Generating Plasma Noise Abstract: $OUTPUT_FILE"
    magick -size "${WIDTH}x${HEIGHT}" \
        plasma:fractal \
        -seed "$SEED" \
        -colorspace RGB \
        -separate \
        -evaluate set "$COLOR1" \
        -swap 0,1 \
        -evaluate set "$COLOR2" \
        -combine \
        -modulate 100,150,"$ROUGHNESS" \
        -quality "$JPEG_QUALITY" \
        "$OUTPUT_FILE"
}

# 3. Radial Gradient with Distortion
generate_radial_distortion() {
    local OUTPUT_FILE="$1"
    local COLORS_ARRAY=($(get_n_random_colors 3)) # Get 3 unique colors
    local COLOR1="${COLORS_ARRAY[0]}"
    local COLOR2="${COLORS_ARRAY[1]}"
    local COLOR3="${COLORS_ARRAY[2]}"
    local DISTORTION_TYPE_INDEX=$((RANDOM % 3))
    local DISTORTION_TYPES=("implode" "swirl" "wave")
    local SELECTED_DISTORTION="${DISTORTION_TYPES[$DISTORTION_TYPE_INDEX]}"
    local DISTORTION_PARAM=$((RANDOM % 50 - 25)) # -25 to 25 for implode/swirl, or wave params

    log INFO "Generating Radial Gradient with ${SELECTED_DISTORTION} distortion: $OUTPUT_FILE"
    magick -size "${WIDTH}x${HEIGHT}" \
        radial-gradient:"$COLOR1"-"$COLOR2"-"$COLOR3" \
        -channel RGB -fx "rand()" \
        -"$SELECTED_DISTORTION" "$DISTORTION_PARAM" \
        -quality "$JPEG_QUALITY" \
        "$OUTPUT_FILE"
}

# 4. Colorful Stripes with Blur and Overlay
generate_stripes_overlay() {
    local OUTPUT_FILE="$1"
    local COLOR1=$(get_random_color)
    local COLOR2=$(get_random_color)
    local STRIPE_WIDTH=$((RANDOM % 50 + 20)) # 20 to 70 pixels
    local BLUR_AMOUNT=$((RANDOM % 10 + 3)) # 3 to 12
    local ANGLE=$((RANDOM % 180)) # 0 to 179 degrees

    log INFO "Generating Colorful Stripes with Blur: $OUTPUT_FILE"
    magick -size "${WIDTH}x${HEIGHT}" \
        tile:"$COLOR1" \
        -draw "fill $COLOR2 rectangle 0,0 ${STRIPE_WIDTH},${HEIGHT}" \
        -tile \
        -rotate "$ANGLE" \
        -blur 0x"$BLUR_AMOUNT" \
        -quality "$JPEG_QUALITY" \
        "$OUTPUT_FILE"
}

# 5. Simple Color Fill with Noise and Vignette
generate_solid_noise_vignette() {
    local OUTPUT_FILE="$1"
    local FILL_COLOR=$(get_random_color)
    local NOISE_TYPE_INDEX=$((RANDOM % 3))
    local NOISE_TYPES=("random" "gaussian" "laplacian")
    local SELECTED_NOISE="${NOISE_TYPES[$NOISE_TYPE_INDEX]}"
    local VIGNETTE_RADIUS=$((RANDOM % 50 + 20)) # 20 to 70 for vignette

    log INFO "Generating Solid Color with Noise and Vignette: $OUTPUT_FILE"
    magick -size "${WIDTH}x${HEIGHT}" \
        "xc:$FILL_COLOR" \
        "+noise" "$SELECTED_NOISE" \
        -modulate 100,120 \
        -vignette "0x${VIGNETTE_RADIUS}" \
        -quality "$JPEG_QUALITY" \
        "$OUTPUT_FILE"
}

##############################################################################
#                                Main Script                                 #
##############################################################################

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR" || { log ERROR "Failed to create output directory: $OUTPUT_DIR"; exit 1; }
log INFO "Wallpapers will be saved in: $OUTPUT_DIR"
log INFO "Generating $NUM_WALLPAPERS 4K ($WIDTH x $HEIGHT) JPEG wallpapers..."

# Array of generation functions
declare -a GENERATION_FUNCTIONS=(
    "generate_gradient_swirl"
    "generate_plasma_noise"
    "generate_radial_distortion"
    "generate_stripes_overlay"
    "generate_solid_noise_vignette"
)

for (( i=1; i<=NUM_WALLPAPERS; i++ )); do
    TIMESTAMP=$(date +%Y%m%d_%H%M%S_%N) # Add nanoseconds for more uniqueness
    OUTPUT_FILENAME="${OUTPUT_DIR}/wallpaper_${TIMESTAMP}.jpg"

    # Randomly select a generation function
    SELECTED_FUNCTION="${GENERATION_FUNCTIONS[$((RANDOM % ${#GENERATION_FUNCTIONS[@]}))]}"

    # Execute the selected function
    if "$SELECTED_FUNCTION" "$OUTPUT_FILENAME"; then
        log SUCCESS "Generated: $OUTPUT_FILENAME"
    else
        log ERROR "Failed to generate: $OUTPUT_FILENAME"
    fi
done

log INFO "Finished generating $NUM_WALLPAPERS wallpapers."
log INFO "You can find them in the '$OUTPUT_DIR' directory."

exit 0

