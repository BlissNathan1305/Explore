from PIL import Image, ImageDraw, ImageFilter
import random
import math
import os

# Constants for 4K mobile portrait
WIDTH = 2160
HEIGHT = 3840

# Output directory
os.makedirs("wallpapers", exist_ok=True)

def random_color():
    return tuple(random.randint(0, 255) for _ in range(3))

def draw_geometric_pattern(draw):
    spacing = 120
    for x in range(0, WIDTH, spacing):
        draw.line([(x, 0), (x, HEIGHT)], fill=random_color(), width=2)
    for y in range(0, HEIGHT, spacing):
        draw.line([(0, y), (WIDTH, y)], fill=random_color(), width=2)
    for i in range(200):
        radius = random.randint(20, 80)
        x = random.randint(0, WIDTH)
        y = random.randint(0, HEIGHT)
        draw.ellipse([x - radius, y - radius, x + radius, y + radius], outline=random_color(), width=2)

def add_noise(img):
    pixels = img.load()
    for y in range(HEIGHT):
        for x in range(WIDTH):
            r, g, b = pixels[x, y]
            noise = random.randint(-20, 20)
            pixels[x, y] = (
                min(255, max(0, r + noise)),
                min(255, max(0, g + noise)),
                min(255, max(0, b + noise))
            )
    return img

def generate_wallpaper(filename="wallpaper.jpg"):
    # Create background
    bg_color = random_color()
    image = Image.new("RGB", (WIDTH, HEIGHT), bg_color)
    draw = ImageDraw.Draw(image)

    # Draw pattern
    draw_geometric_pattern(draw)

    # Add noise
    image = add_noise(image)

    # Optional: smooth filter for a softer look
    image = image.filter(ImageFilter.SMOOTH)

    # Save as high-quality JPEG
    output_path = os.path.join("wallpapers", filename)
    image.save(output_path, "JPEG", quality=95, optimize=True)

    print(f"Wallpaper saved at: {output_path}")

# Example: generate 2 wallpapers
for i in range(2):
    generate_wallpaper(f"geometric_wallpaper_{i+1}.jpg")
