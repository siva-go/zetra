import base64
import re
import os
import sys

def main():
    svg_path = r"c:\dev\zetra\assets\images\car_turn.svg"
    out_dir = r"c:\dev\zetra\assets\images"
    
    if not os.path.exists(svg_path):
        print(f"Error: SVG file not found at {svg_path}")
        sys.exit(1)
        
    print(f"Reading SVG from {svg_path}...")
    with open(svg_path, 'r', encoding='utf-8') as f:
        svg_content = f.read()
        
    # Find all data:image/png;base64 matches
    matches = re.findall(r'xlink:href="data:image/png;base64,([^"]+)"', svg_content)
    if not matches:
        # Check standard href without xlink namespace
        matches = re.findall(r'href="data:image/png;base64,([^"]+)"', svg_content)
        
    print(f"Found {len(matches)} base64 images in SVG.")
    
    if len(matches) < 2:
        print("Expected at least 2 images (mask and color). Trying to decode whatever is found.")
        for i, img_b64 in enumerate(matches):
            img_data = base64.b64decode(img_b64)
            out_path = os.path.join(out_dir, f"extracted_car_part_{i}.png")
            with open(out_path, 'wb') as out_f:
                out_f.write(img_data)
            print(f"Saved part {i} to {out_path}")
        sys.exit(0)
        
    # Decode mask and color images
    mask_data = base64.b64decode(matches[0])
    color_data = base64.b64decode(matches[1])
    
    mask_temp_path = os.path.join(out_dir, "temp_mask.png")
    color_temp_path = os.path.join(out_dir, "temp_color.png")
    
    with open(mask_temp_path, 'wb') as f:
        f.write(mask_data)
    with open(color_temp_path, 'wb') as f:
        f.write(color_data)
        
    print("Decoded raw images. Attempting to combine them using Pillow...")
    
    try:
        from PIL import Image
    except ImportError:
        print("Pillow not installed. Installing Pillow...")
        import subprocess
        subprocess.check_call([sys.executable, "-m", "pip", "install", "Pillow"])
        from PIL import Image
        
    mask_img = Image.open(mask_temp_path).convert('L')
    color_img = Image.open(color_temp_path).convert('RGBA')
    
    # Create final transparent image
    r, g, b, a = color_img.split()
    # Use mask_img as alpha channel
    final_img = Image.merge('RGBA', (r, g, b, mask_img))
    
    final_path = os.path.join(out_dir, "car_turn.png")
    final_img.save(final_path, 'PNG')
    print(f"Success! Combined transparent image saved to {final_path}")
    
    # Clean up temporary files
    try:
        os.remove(mask_temp_path)
        os.remove(color_temp_path)
        print("Cleaned up temporary files.")
    except Exception as e:
        print(f"Warning: Could not remove temporary files: {e}")

if __name__ == '__main__':
    main()
