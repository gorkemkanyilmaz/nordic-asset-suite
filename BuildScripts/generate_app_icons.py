import os
import json
from PIL import Image, ImageDraw

APPS = {
    "ApplianceWarrantyManager": {
        "bg_start": (24, 75, 160),     # Deep Nordic Blue
        "bg_end": (15, 30, 70),        # Midnight Navy
        "accent": (64, 224, 208),      # Cyan/Turquoise Shield
        "title": "AWM",
        "symbol": "SHIELD"
    },
    "SkiGearTracker": {
        "bg_start": (14, 116, 144),    # Alpine Cyan
        "bg_end": (15, 23, 42),        # Slate Navy
        "accent": (56, 189, 248),      # Ice Blue
        "title": "SKI",
        "symbol": "MOUNTAIN"
    },
    "EBikeServiceTracker": {
        "bg_start": (194, 65, 12),     # Electric Amber / Orange
        "bg_end": (24, 24, 27),        # Dark Titanium
        "accent": (251, 191, 36),      # Amber Glow
        "title": "BIKE",
        "symbol": "BOLT"
    },
    "CoffeeMachineCompanion": {
        "bg_start": (120, 53, 15),     # Espresso Roast
        "bg_end": (28, 25, 23),        # Dark Bronze Stone
        "accent": (245, 158, 11),      # Crema Gold
        "title": "COFFEE",
        "symbol": "CUP"
    }
}

def draw_gradient_background(size, start_col, end_col):
    img = Image.new("RGB", (size, size), start_col)
    draw = ImageDraw.Draw(img)
    for y in range(size):
        ratio = y / float(size)
        r = int(start_col[0] * (1 - ratio) + end_col[0] * ratio)
        g = int(start_col[1] * (1 - ratio) + end_col[1] * ratio)
        b = int(start_col[2] * (1 - ratio) + end_col[2] * ratio)
        draw.line([(0, y), (size, y)], fill=(r, g, b))
    return img

def render_master_icon(app_name, config):
    size = 1024
    img = draw_gradient_background(size, config["bg_start"], config["bg_end"])
    draw = ImageDraw.Draw(img)
    
    # Outer elegant ring
    margin = 80
    draw.ellipse(
        [(margin, margin), (size - margin, size - margin)],
        outline=(255, 255, 255, 60),
        width=12
    )
    
    # Inner glowing shape depending on app
    accent = config["accent"]
    sym = config["symbol"]
    
    if sym == "SHIELD":
        # Warranty Shield
        pts = [
            (512, 220),
            (760, 320),
            (720, 640),
            (512, 820),
            (304, 640),
            (264, 320)
        ]
        draw.polygon(pts, fill=(*accent, 220), outline=(255, 255, 255), width=8)
        # Checkmark inside shield
        draw.line([(420, 520), (480, 580), (620, 440)], fill=(255, 255, 255), width=32)
    elif sym == "MOUNTAIN":
        # Ski Mountain peaks
        pts1 = [(512, 260), (740, 760), (284, 760)]
        pts2 = [(680, 420), (840, 760), (520, 760)]
        draw.polygon(pts2, fill=(*accent, 160), outline=(255, 255, 255), width=6)
        draw.polygon(pts1, fill=(*accent, 230), outline=(255, 255, 255), width=8)
        # Snow cap
        cap = [(512, 260), (570, 390), (520, 370), (460, 390)]
        draw.polygon(cap, fill=(255, 255, 255))
    elif sym == "BOLT":
        # E-Bike Energy Bolt
        bolt = [
            (560, 220),
            (360, 540),
            (490, 540),
            (450, 820),
            (680, 480),
            (540, 480)
        ]
        draw.polygon(bolt, fill=(*accent, 240), outline=(255, 255, 255), width=10)
    elif sym == "CUP":
        # Coffee Steam & Cup
        # Cup body
        draw.rounded_rectangle([(340, 440), (684, 740)], radius=60, fill=(*accent, 230), outline=(255, 255, 255), width=8)
        # Cup Handle
        draw.arc([(620, 480), (760, 660)], start=270, end=90, fill=(255, 255, 255), width=18)
        # Steam waves
        for x_offset in [-70, 0, 70]:
            draw.arc([(512 + x_offset - 30, 260), (512 + x_offset + 30, 380)], start=210, end=330, fill=(255, 255, 255), width=12)
            
    return img

def generate_all():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    base_dir = os.path.dirname(script_dir) # project root
    
    for app_name, config in APPS.items():
        appicon_dir = os.path.join(base_dir, app_name, "Assets.xcassets", "AppIcon.appiconset")
        
        # Clean directory first
        if os.path.exists(appicon_dir):
            for f in os.listdir(appicon_dir):
                os.remove(os.path.join(appicon_dir, f))
        else:
            os.makedirs(appicon_dir, exist_ok=True)
        
        # Top-level Assets.xcassets Contents.json
        top_contents = {
            "info": {
                "author": "xcode",
                "version": 1
            }
        }
        with open(os.path.join(base_dir, app_name, "Assets.xcassets", "Contents.json"), "w") as f:
            json.dump(top_contents, f, indent=2)
            
        master = render_master_icon(app_name, config)
        icon_path = os.path.join(appicon_dir, "AppIcon-1024.png")
        master.save(icon_path, "PNG")
        
        # Standard Xcode 15/16 Universal Single-Size App Icon specification
        appicon_contents = {
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
        with open(os.path.join(appicon_dir, "Contents.json"), "w") as f:
            json.dump(appicon_contents, f, indent=2)
            
        print(f"Generated single-size AppIcon for {app_name} -> {icon_path}")

if __name__ == "__main__":
    generate_all()
