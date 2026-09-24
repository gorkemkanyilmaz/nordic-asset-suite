import os
import json
import math
from PIL import Image, ImageDraw, ImageFilter

def create_gradient(size, start_rgb, end_rgb, direction="diagonal"):
    img = Image.new("RGB", (size, size), start_rgb)
    draw = ImageDraw.Draw(img)
    for i in range(size):
        ratio = i / float(size)
        r = int(start_rgb[0] * (1 - ratio) + end_rgb[0] * ratio)
        g = int(start_rgb[1] * (1 - ratio) + end_rgb[1] * ratio)
        b = int(start_rgb[2] * (1 - ratio) + end_rgb[2] * ratio)
        if direction == "vertical":
            draw.line([(0, i), (size, i)], fill=(r, g, b))
        else: # diagonal
            # soft diagonal shading
            draw.line([(0, i), (size, i)], fill=(r, g, b))
    return img

def render_appliance_icon(size=2048):
    # Deep Nordic Navy Gradient
    bg = create_gradient(size, (10, 18, 38), (18, 36, 74), "vertical")
    
    # Subtle radial glow from top-center
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    for r in range(size // 2, 0, -10):
        alpha = int((1 - (r / (size // 2))) * 40)
        glow_draw.ellipse([size // 2 - r, size // 3 - r, size // 2 + r, size // 3 + r], fill=(56, 189, 248, alpha))
    bg.paste(glow, (0, 0), glow)
    
    draw = ImageDraw.Draw(bg, "RGBA")
    
    # Minimalist Architectural Shield
    # Elegant proportions
    cx, cy = size // 2, size // 2 + 30
    w, h = 480, 560
    
    shield_pts = [
        (cx, cy - h + 100),            # Top peak
        (cx + w, cy - h + 180),        # Top right shoulder
        (cx + w - 40, cy + 140),       # Mid right
        (cx, cy + h - 80),             # Bottom tip
        (cx - w + 40, cy + 140),       # Mid left
        (cx - w, cy - h + 180)         # Top left shoulder
    ]
    
    # Outer subtle rim glow
    draw.polygon(shield_pts, fill=(14, 165, 233, 40))
    
    # Main Shield Body (Solid sleek frosted cyan-slate)
    inner_pts = [
        (cx, cy - h + 130),
        (cx + w - 35, cy - h + 200),
        (cx + w - 70, cy + 120),
        (cx, cy + h - 120),
        (cx - w + 70, cy + 120),
        (cx - w + 35, cy - h + 200)
    ]
    draw.polygon(inner_pts, fill=(2, 132, 199, 230), outline=(56, 189, 248, 255), width=24)
    
    # Crisp Architectural Home Silhouette inside Shield
    house_pts = [
        (cx, cy - 180),             # Roof apex
        (cx + 200, cy - 20),        # Roof right eave
        (cx + 140, cy - 20),        # Wall right start
        (cx + 140, cy + 180),       # Wall right bottom
        (cx - 140, cy + 180),       # Wall left bottom
        (cx - 140, cy - 20),        # Wall left start
        (cx - 200, cy - 20)         # Roof left eave
    ]
    draw.polygon(house_pts, fill=(255, 255, 255, 255))
    
    # Crisp Modern Checkmark inside House (representing warranty certified)
    chk = [
        (cx - 60, cy + 70),
        (cx - 10, cy + 120),
        (cx + 70, cy + 20)
    ]
    draw.line(chk, fill=(2, 132, 199, 255), width=32, joint="curve")
    
    # Subtle bottom accent bar
    draw.rounded_rectangle([cx - 120, cy + 320, cx + 120, cy + 338], radius=9, fill=(56, 189, 248, 180))
    
    return bg

def render_coffee_icon(size=2048):
    # Warm Roasted Espresso Obsidian Gradient
    bg = create_gradient(size, (22, 15, 12), (38, 26, 20), "vertical")
    
    # Warm ambient crema glow
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    for r in range(size // 2, 0, -10):
        alpha = int((1 - (r / (size // 2))) * 45)
        glow_draw.ellipse([size // 2 - r, size // 2 - r, size // 2 + r, size // 2 + r], fill=(245, 158, 11, alpha))
    bg.paste(glow, (0, 0), glow)
    
    draw = ImageDraw.Draw(bg, "RGBA")
    cx, cy = size // 2, size // 2 + 50
    
    # Minimalist Ceramic Espresso Cup (Bold, clean Apple HIG silhouette)
    cup_left = cx - 340
    cup_right = cx + 220
    cup_top = cy - 100
    cup_bottom = cy + 320
    
    # Saucer plate underneath
    draw.rounded_rectangle([cx - 420, cy + 330, cx + 300, cy + 375], radius=22, fill=(245, 158, 11, 230))
    
    # Cup handle (smooth geometry)
    draw.arc([cx + 100, cy - 40, cx + 420, cy + 240], start=290, end=70, fill=(245, 158, 11, 255), width=48)
    
    # Cup body
    draw.rounded_rectangle([cup_left, cup_top, cup_right, cup_bottom], radius=110, fill=(255, 255, 255, 255))
    
    # Crema top layer inside cup
    draw.ellipse([cup_left + 24, cup_top + 16, cup_right - 24, cup_top + 110], fill=(217, 119, 6, 255))
    draw.ellipse([cup_left + 60, cup_top + 34, cup_right - 60, cup_top + 92], fill=(245, 158, 11, 255))
    
    # Modern Geometric Steam Curves (Refined & balanced, not messy)
    steam_color = (245, 158, 11, 210)
    for offset_x in [-180, -60, 60]:
        sx = cx + offset_x
        sy = cup_top - 90
        # Draw smooth wave line
        pts = [
            (sx, sy),
            (sx + 35, sy - 90),
            (sx - 20, sy - 180),
            (sx + 15, sy - 270)
        ]
        draw.line(pts, fill=steam_color, width=28, joint="curve")
        
    return bg

def render_ebike_icon(size=2048):
    # Dark Titanium Carbon Gradient
    bg = create_gradient(size, (16, 18, 22), (28, 34, 44), "vertical")
    
    # Electric safety amber glow
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    for r in range(size // 2, 0, -10):
        alpha = int((1 - (r / (size // 2))) * 45)
        glow_draw.ellipse([size // 2 - r, size // 2 - r, size // 2 + r, size // 2 + r], fill=(249, 115, 22, alpha))
    bg.paste(glow, (0, 0), glow)
    
    draw = ImageDraw.Draw(bg, "RGBA")
    cx, cy = size // 2, size // 2
    
    # High-performance Chainring / Gear Outer Silhouette
    outer_r = 460
    inner_r = 380
    num_teeth = 16
    gear_pts = []
    for i in range(num_teeth * 2):
        angle = i * (math.pi / num_teeth)
        r = outer_r if (i % 2 == 0) else inner_r
        px = cx + r * math.cos(angle)
        py = cy + r * math.sin(angle)
        gear_pts.append((px, py))
    
    draw.polygon(gear_pts, fill=(35, 42, 54, 255), outline=(249, 115, 22, 180), width=18)
    
    # Center cutout / hollow circle for authentic mechanical chainring look
    center_r = 290
    draw.ellipse([cx - center_r, cy - center_r, cx + center_r, cy + center_r], fill=(22, 26, 34, 255), outline=(249, 115, 22, 230), width=16)
    
    # Dynamic Electric Velocity Bolt in Core (Razor-sharp geometry)
    bolt_pts = [
        (cx + 60, cy - 270),    # Top right start
        (cx - 140, cy + 20),    # Mid left tuck
        (cx + 10, cy + 20),     # Inner crook right
        (cx - 70, cy + 280),    # Bottom sharp tip
        (cx + 170, cy - 40),    # Mid right peak
        (cx + 20, cy - 40)      # Inner crook left
    ]
    draw.polygon(bolt_pts, fill=(249, 115, 22, 255), outline=(255, 255, 255, 240), width=14)
    
    return bg

def render_skigear_icon(size=2048):
    # Glacial Alpine Slate Gradient
    bg = create_gradient(size, (11, 20, 36), (18, 34, 58), "vertical")
    
    # Glacial cyan glow
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    for r in range(size // 2, 0, -10):
        alpha = int((1 - (r / (size // 2))) * 45)
        glow_draw.ellipse([size // 2 - r, size // 2 - r, size // 2 + r, size // 2 + r], fill=(56, 189, 248, alpha))
    bg.paste(glow, (0, 0), glow)
    
    draw = ImageDraw.Draw(bg, "RGBA")
    cx, cy = size // 2, size // 2
    
    # Sharp Geometric Twin Alpine Peaks
    # Background peak (slate cyan)
    p2_pts = [(cx + 240, cy - 240), (cx + 560, cy + 340), (cx - 80, cy + 340)]
    draw.polygon(p2_pts, fill=(14, 116, 144, 220), outline=(56, 189, 248, 120), width=10)
    # Snow cap 2
    c2 = [(cx + 240, cy - 240), (cx + 330, cy - 80), (cx + 260, cy - 100), (cx + 150, cy - 80)]
    draw.polygon(c2, fill=(224, 242, 254, 240))
    
    # Foreground primary peak
    p1_pts = [(cx - 160, cy - 380), (cx + 300, cy + 360), (cx - 540, cy + 360)]
    draw.polygon(p1_pts, fill=(2, 132, 199, 240), outline=(56, 189, 248, 255), width=16)
    # Snow cap 1
    c1 = [(cx - 160, cy - 380), (cx - 30, cy - 140), (cx - 130, cy - 170), (cx - 270, cy - 130)]
    draw.polygon(c1, fill=(255, 255, 255, 255))
    
    # Carved Speed Tracks (Twin Alpine Skis carving powder)
    # Left ski track
    draw.arc([cx - 400, cy - 100, cx + 450, cy + 460], start=150, end=300, fill=(255, 255, 255, 255), width=32)
    # Right ski track
    draw.arc([cx - 340, cy - 40, cx + 510, cy + 520], start=150, end=300, fill=(56, 189, 248, 255), width=28)
    
    return bg

def generate_all_icons():
    base_dir = r"c:\Users\Gorkem\Desktop\nordic"
    renderers = {
        "ApplianceWarrantyManager": render_appliance_icon,
        "CoffeeMachineCompanion": render_coffee_icon,
        "EBikeServiceTracker": render_ebike_icon,
        "SkiGearTracker": render_skigear_icon
    }
    
    for app_name, renderer in renderers.items():
        print(f"Rendering master 2048px canvas for {app_name}...")
        high_res = renderer(2048)
        
        # High quality supersampling Lanczos downscale to 1024x1024 for Apple App Store Spec
        icon_1024 = high_res.resize((1024, 1024), Image.Resampling.LANCZOS)
        
        target_dir = os.path.join(base_dir, app_name, "Assets.xcassets", "AppIcon.appiconset")
        os.makedirs(target_dir, exist_ok=True)
        
        out_path = os.path.join(target_dir, "AppIcon-1024.png")
        icon_1024.save(out_path, "PNG", optimize=True)
        
        # Write clean standard Xcode Contents.json
        contents = {
            "images": [
                {
                    "filename": "AppIcon-1024.png",
                    "idiom": "universal",
                    "platform": "ios",
                    "size": "1024x1024"
                }
            ],
            "info": {
                "author": "xcode",
                "version": 1
            }
        }
        with open(os.path.join(target_dir, "Contents.json"), "w") as f:
            json.dump(contents, f, indent=2)
            
        print(f"-> Successfully saved 1024x1024 icon to {out_path}")

if __name__ == "__main__":
    generate_all_icons()
