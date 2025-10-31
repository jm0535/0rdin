#!/usr/bin/env python3
"""
Generate Ö icon for Ördin application
Creates PNG icons in various sizes for Windows/macOS/Linux taskbar/dock

Requirements: pip install pillow
"""

from PIL import Image, ImageDraw, ImageFont
import os

def generate_icon(size, output_path):
    """Generate a single icon of specified size"""
    # Create image with dark background (VS Code navbar color)
    img = Image.new('RGB', (size, size), color='#2d2d30')
    draw = ImageDraw.Draw(img)
    
    # Calculate font size (about 75% of image size)
    font_size = int(size * 0.75)
    
    try:
        # Try to use Arial (Windows/macOS)
        font = ImageFont.truetype("arial.ttf", font_size)
    except:
        try:
            # Try Liberation Sans (Linux)
            font = ImageFont.truetype("/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf", font_size)
        except:
            # Fallback to default font
            font = ImageFont.load_default()
            print(f"  Warning: Using default font for {size}×{size}")
    
    # Draw Ö symbol in green
    text = "Ö"
    
    # Get text bounding box for centering
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    # Calculate position to center text
    x = (size - text_width) // 2 - bbox[0]
    y = (size - text_height) // 2 - bbox[1]
    
    # Draw text in green (#2e8b57)
    draw.text((x, y), text, fill='#2e8b57', font=font)
    
    # Save image
    img.save(output_path, 'PNG')
    print(f"✓ Generated: {output_path} ({size}×{size})")

def main():
    print("Generating Ö icons for Ördin...\n")
    
    # Build directory (same as script location)
    build_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Icon sizes to generate
    sizes = [
        (16, 'icon-16.png'),
        (32, 'icon-32.png'),
        (48, 'icon-48.png'),
        (64, 'icon-64.png'),
        (128, 'icon-128.png'),
        (256, 'icon.png'),       # Main icon
        (512, 'icon-512.png'),
        (1024, 'icon-1024.png')
    ]
    
    # Generate all icons
    for size, filename in sizes:
        output_path = os.path.join(build_dir, filename)
        generate_icon(size, output_path)
    
    print("\n✓ All icons generated successfully!")
    print("\nMain icons:")
    print("  - icon.png (256×256) - For Windows/Linux taskbar")
    print("  - icon-512.png (512×512) - For macOS dock and high-DPI")
    print("  - icon-1024.png (1024×1024) - For macOS Retina displays")
    print("\nTo use in Electron, rebuild the app:")
    print("  npm run make")

if __name__ == '__main__':
    try:
        main()
    except ImportError:
        print("Error: Pillow library not installed.")
        print("Install with: pip install pillow")
        print("\nAlternative: Open build/generate-o-icon.html in a browser")
        print("and download the icons manually.")
