#!/usr/bin/env python3
"""
Nordic Asset Suite — High-Resolution Marketing App Store Screenshot Generator
Generates pixel-perfect, conversion-optimized marketing preview screenshots:
- iPhone 6.7" Display (1290 x 2796 px)
- iPad Pro 12.9" Display (2048 x 2732 px)

Strictly authentic to each app's UI, styled with premium Swiss Nordic framing and ASO headlines.
"""

import os
import math
from PIL import Image, ImageDraw, ImageFont

OUTPUT_BASE = r"C:\Users\Gorkem\Desktop\nordic\AppStoreMetadata\Screenshots"
os.makedirs(os.path.join(OUTPUT_BASE, "iPhone"), exist_ok=True)
os.makedirs(os.path.join(OUTPUT_BASE, "iPad"), exist_ok=True)

FONT_REGULAR = r"C:\Windows\Fonts\segoeui.ttf"
FONT_BOLD = r"C:\Windows\Fonts\segoeuib.ttf"
FONT_BLACK = r"C:\Windows\Fonts\arialbd.ttf"

def get_font(path, size):
    try:
        return ImageFont.truetype(path, size)
    except Exception:
        return ImageFont.load_default()

def draw_rounded_rect(draw, bbox, radius, fill=None, outline=None, width=1):
    draw.rounded_rectangle(bbox, radius=radius, fill=fill, outline=outline, width=width)

def draw_gradient_background(width, height, top_color, bottom_color, glow_color=None, glow_center=None, glow_radius=400):
    img = Image.new("RGB", (width, height), top_color)
    draw = ImageDraw.Draw(img)
    
    # Linear top-down gradient
    r1, g1, b1 = top_color
    r2, g2, b2 = bottom_color
    for y in range(height):
        t = y / float(height)
        r = int(r1 + (r2 - r1) * t)
        g = int(g1 + (g2 - g1) * t)
        b = int(b1 + (b2 - b1) * t)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    # Ambient radial glow if requested
    if glow_color and glow_center:
        cx, cy = glow_center
        gr, gg, gb = glow_color
        glow_layer = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        gdraw = ImageDraw.Draw(glow_layer)
        for r_step in range(glow_radius, 0, -20):
            alpha = int(45 * (1.0 - (r_step / float(glow_radius))))
            gdraw.ellipse([cx - r_step, cy - r_step, cx + r_step, cy + r_step], fill=(gr, gg, gb, alpha))
        
        img = Image.alpha_composite(img.convert("RGBA"), glow_layer).convert("RGB")
    
    return img

def render_iphone_frame(canvas, screen_img, x, y, width, height):
    """Draws an ultra-sleek iPhone 16 Pro device mockup with Dynamic Island and titanium bezel."""
    draw = ImageDraw.Draw(canvas)
    
    # Outer drop shadow
    shadow_offset = 14
    for i in range(20, 0, -2):
        alpha = int(35 * (1.0 - i / 20.0))
        draw.rounded_rectangle(
            [x - i, y - i + shadow_offset, x + width + i, y + height + i + shadow_offset],
            radius=64,
            outline=(0, 0, 0, alpha),
            width=2
        )
    
    # Titanium Bezel Rim
    draw.rounded_rectangle([x - 12, y - 12, x + width + 12, y + height + 12], radius=68, fill=(45, 52, 64), outline=(75, 85, 100), width=2)
    # Inner Black Bezel
    draw.rounded_rectangle([x - 4, y - 4, x + width + 4, y + height + 4], radius=60, fill=(10, 14, 20))
    
    # Paste actual screen image with rounded mask
    mask = Image.new("L", (width, height), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, width, height], radius=54, fill=255)
    
    canvas.paste(screen_img, (x, y), mask)
    
    # Dynamic Island
    di_width = 160
    di_height = 42
    di_x = x + (width - di_width) // 2
    di_y = y + 18
    draw.rounded_rectangle([di_x, di_y, di_x + di_width, di_y + di_height], radius=21, fill=(0, 0, 0))
    # Camera lens reflection
    draw.ellipse([di_x + di_width - 34, di_y + 13, di_x + di_width - 18, di_y + 29], fill=(12, 18, 30))

# MARK: - Appliance Screen Renders
def render_appliance_screen_1(w=960, h=1980):
    """Dashboard Vault Screen"""
    img = Image.new("RGBA", (w, h), (8, 12, 20, 255))
    draw = ImageDraw.Draw(img)
    
    # Status Bar
    font_status = get_font(FONT_BOLD, 28)
    draw.text((60, 24), "9:41", font=font_status, fill=(255, 255, 255))
    
    # Nav Header
    font_sub = get_font(FONT_REGULAR, 26)
    font_title = get_font(FONT_BOLD, 46)
    draw.text((40, 90), "ZURICH RESIDENCE", font=font_sub, fill=(56, 189, 248))
    draw.text((40, 130), "Home Appliance Vault", font=font_title, fill=(255, 255, 255))
    
    # Top Metrics Bar (3 Cards)
    metric_labels = [("TOTAL ASSETS", "8", (255, 255, 255)), ("ACTIVE WARRANTIES", "6", (52, 211, 153)), ("HEALTH SCORE", "94%", (56, 189, 248))]
    for i, (lbl, val, col) in enumerate(metric_labels):
        card_x = 40 + i * 296
        draw_rounded_rect(draw, [card_x, 210, card_x + 280, 310], 18, fill=(19, 27, 46), outline=(30, 41, 59), width=2)
        draw.text((card_x + 20, 226), lbl, font=get_font(FONT_BOLD, 18), fill=(148, 163, 184))
        draw.text((card_x + 20, 254), val, font=get_font(FONT_BOLD, 36), fill=col)
    
    # Appliance Card 1: Samsung TV
    draw_rounded_rect(draw, [40, 340, w - 40, 520], 22, fill=(19, 27, 46), outline=(56, 189, 248), width=2)
    # Thumbnail Box
    draw_rounded_rect(draw, [60, 360, 180, 480], 16, fill=(30, 41, 59))
    draw.text((95, 400), "TV", font=get_font(FONT_BOLD, 36), fill=(56, 189, 248))
    draw.text((205, 365), "LIVING ROOM", font=get_font(FONT_BOLD, 18), fill=(56, 189, 248))
    draw.text((205, 395), "Samsung QN85D Neo QLED 65\"", font=get_font(FONT_BOLD, 28), fill=(255, 255, 255))
    draw.text((205, 435), "Serial: 0X9A-88219-K · CHF 1,899", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
    # Badge
    draw_rounded_rect(draw, [w - 230, 360, w - 60, 405], 14, fill=(6, 78, 59))
    draw.text((w - 215, 372), "ACTIVE (480d)", font=get_font(FONT_BOLD, 18), fill=(52, 211, 153))
    
    # Appliance Card 2: Miele Washing Machine
    draw_rounded_rect(draw, [40, 545, w - 40, 725], 22, fill=(19, 27, 46), outline=(30, 41, 59), width=2)
    draw_rounded_rect(draw, [60, 565, 180, 685], 16, fill=(30, 41, 59))
    draw.text((85, 605), "WASH", font=get_font(FONT_BOLD, 28), fill=(56, 189, 248))
    draw.text((205, 570), "LAUNDRY ROOM", font=get_font(FONT_BOLD, 18), fill=(56, 189, 248))
    draw.text((205, 600), "Miele W1 TwinDos Excellence", font=get_font(FONT_BOLD, 28), fill=(255, 255, 255))
    draw.text((205, 640), "Serial: ML-99201-B · CHF 2,450", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
    draw_rounded_rect(draw, [w - 230, 565, w - 60, 610], 14, fill=(6, 78, 59))
    draw.text((w - 215, 577), "ACTIVE (612d)", font=get_font(FONT_BOLD, 18), fill=(52, 211, 153))

    # Appliance Card 3: V-ZUG Oven
    draw_rounded_rect(draw, [40, 750, w - 40, 930], 22, fill=(19, 27, 46), outline=(30, 41, 59), width=2)
    draw_rounded_rect(draw, [60, 770, 180, 890], 16, fill=(30, 41, 59))
    draw.text((88, 810), "OVEN", font=get_font(FONT_BOLD, 28), fill=(56, 189, 248))
    draw.text((205, 775), "KITCHEN", font=get_font(FONT_BOLD, 18), fill=(56, 189, 248))
    draw.text((205, 805), "V-ZUG Combair V4000", font=get_font(FONT_BOLD, 28), fill=(255, 255, 255))
    draw.text((205, 845), "Serial: VZ-44102-CH · CHF 3,190", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
    draw_rounded_rect(draw, [w - 230, 770, w - 60, 815], 14, fill=(120, 53, 15))
    draw.text((w - 215, 782), "EXPIRING (34d)", font=get_font(FONT_BOLD, 18), fill=(251, 191, 36))

    # Bottom Tab Bar
    draw.rectangle([0, h - 140, w, h], fill=(13, 19, 33))
    draw.line([(0, h - 140), (w, h - 140)], fill=(30, 41, 59), width=2)
    tabs = ["Home", "Appliances", "Warranties", "Settings"]
    for i, t in enumerate(tabs):
        tx = 60 + i * 220
        col = (56, 189, 248) if i == 0 else (148, 163, 184)
        draw.text((tx, h - 85), t, font=get_font(FONT_BOLD, 24), fill=col)

    return img

def render_appliance_screen_2(w=960, h=1980):
    """AI Vision Scanner & OCR Intake"""
    img = Image.new("RGBA", (w, h), (8, 12, 20, 255))
    draw = ImageDraw.Draw(img)
    
    # Camera Viewfinder Mock
    draw.rounded_rectangle([40, 100, w - 40, 750], radius=28, fill=(15, 23, 42), outline=(56, 189, 248), width=3)
    # Crosshair Corners
    cw = 40
    # Top-left
    draw.line([(80, 160), (80 + cw, 160)], fill=(56, 189, 248), width=4)
    draw.line([(80, 160), (80, 160 + cw)], fill=(56, 189, 248), width=4)
    # Top-right
    draw.line([(w - 80 - cw, 160), (w - 80, 160)], fill=(56, 189, 248), width=4)
    draw.line([(w - 80, 160), (w - 80, 160 + cw)], fill=(56, 189, 248), width=4)
    # Bottom-left
    draw.line([(80, 690), (80 + cw, 690)], fill=(56, 189, 248), width=4)
    draw.line([(80, 690 - cw), (80, 690)], fill=(56, 189, 248), width=4)
    # Bottom-right
    draw.line([(w - 80 - cw, 690), (w - 80, 690)], fill=(56, 189, 248), width=4)
    draw.line([(w - 80, 690 - cw), (w - 80, 690)], fill=(56, 189, 248), width=4)
    
    # Scanned Invoice Sample Text Inside Camera
    draw.text((120, 260), "DIGITEC GALAXUS AG — RECEIPT #981240", font=get_font(FONT_BOLD, 24), fill=(148, 163, 184))
    draw.text((120, 310), "Article: Dyson V15 Detect Absolute Extra", font=get_font(FONT_BOLD, 30), fill=(255, 255, 255))
    draw.text((120, 360), "Serial: DY-90812-V15 · Date: 12.04.2025", font=get_font(FONT_REGULAR, 24), fill=(203, 213, 225))
    draw.text((120, 410), "Warranty: 24 Months Official Manufacturer", font=get_font(FONT_BOLD, 24), fill=(52, 211, 153))
    
    # Real-time Green Bounding Box
    draw.rounded_rectangle([100, 240, w - 100, 480], radius=16, outline=(52, 211, 153), width=3)
    draw_rounded_rect(draw, [120, 440, 360, 474], 8, fill=(6, 78, 59))
    draw.text((130, 448), "OCR CONFIDENCE 99.4%", font=get_font(FONT_BOLD, 18), fill=(52, 211, 153))
    
    # AI Gemini Match Card Below
    draw_rounded_rect(draw, [40, 790, w - 40, 1180], 24, fill=(19, 27, 46), outline=(56, 189, 248), width=2)
    draw.text((70, 820), "AI AUTOMATIC PRODUCT IDENTIFICATION", font=get_font(FONT_BOLD, 20), fill=(56, 189, 248))
    draw.text((70, 860), "Dyson V15 Detect Cordless Vacuum", font=get_font(FONT_BOLD, 32), fill=(255, 255, 255))
    draw.text((70, 910), "Auto-Linked: Official Maintenance Manual & Parts Schedule", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
    
    # Feature Pills
    pills = ["HEPA Filter Care", "Laser Fluffy Roller", "2-Year Swiss Warranty"]
    for i, p in enumerate(pills):
        px = 70 + i * 260
        draw_rounded_rect(draw, [px, 970, px + 245, 1020], 12, fill=(30, 41, 59))
        draw.text((px + 20, 985), p, font=get_font(FONT_BOLD, 18), fill=(255, 255, 255))
        
    # Save CTA Button
    draw_rounded_rect(draw, [70, 1060, w - 70, 1140], 18, fill=(56, 189, 248))
    draw.text((w // 2 - 140, 1085), "Save to Household Vault", font=get_font(FONT_BOLD, 26), fill=(8, 12, 20))
    
    return img

def render_appliance_screen_3(w=960, h=1980):
    """Error Diagnostics & Spare Parts"""
    img = Image.new("RGBA", (w, h), (8, 12, 20, 255))
    draw = ImageDraw.Draw(img)
    
    draw.text((40, 80), "ERROR DECODER & REPAIR GUIDE", font=get_font(FONT_BOLD, 20), fill=(244, 63, 94))
    draw.text((40, 120), "Miele Error Code: E40", font=get_font(FONT_BOLD, 42), fill=(255, 255, 255))
    draw.text((40, 175), "Detected issue: Drainage pump blockage or clogged drain hose", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
    
    # Urgency Card
    draw_rounded_rect(draw, [40, 230, w - 40, 360], 20, fill=(45, 15, 25), outline=(244, 63, 94), width=2)
    draw.text((70, 255), "SEVERITY: MEDIUM · WORKSHOP REPAIR NOT REQUIRED", font=get_font(FONT_BOLD, 20), fill=(251, 113, 133))
    draw.text((70, 295), "Self-fixable at home in approx. 15 minutes without tools.", font=get_font(FONT_REGULAR, 22), fill=(255, 255, 255))
    
    # 3-Step Guide Card
    draw_rounded_rect(draw, [40, 390, w - 40, 780], 22, fill=(19, 27, 46), outline=(30, 41, 59), width=2)
    draw.text((70, 420), "ACTIONABLE STEP-BY-STEP REPAIR", font=get_font(FONT_BOLD, 20), fill=(56, 189, 248))
    
    steps = [
        ("Step 1: Open Flap", "Locate access flap on the bottom-left front panel. Place a shallow tray."),
        ("Step 2: Unscrew Lint Filter", "Slowly rotate filter cap counter-clockwise to drain trapped water."),
        ("Step 3: Check Impeller", "Check if foreign objects (coins, hairpins) obstruct pump impeller rotation.")
    ]
    for i, (st, desc) in enumerate(steps):
        sy = 480 + i * 95
        draw_rounded_rect(draw, [70, sy, 105, sy + 35], 8, fill=(56, 189, 248))
        draw.text((78, sy + 6), str(i+1), font=get_font(FONT_BOLD, 20), fill=(8, 12, 20))
        draw.text((120, sy), st, font=get_font(FONT_BOLD, 22), fill=(255, 255, 255))
        draw.text((120, sy + 32), desc, font=get_font(FONT_REGULAR, 18), fill=(148, 163, 184))
        
    # Spare Parts Wear Schedule
    draw.text((40, 820), "PREDICTIVE SPARE PARTS LIFESPAN", font=get_font(FONT_BOLD, 20), fill=(56, 189, 248))
    parts = [("Magnetic Door Perimeter Gasket", 0.75, "75% - Healthy"), ("TwinDos Dispenser Check Valve", 0.35, "35% - Replace in 60d"), ("Drainage Pump Filter O-Ring", 0.90, "90% - Optimal")]
    for i, (part, pct, status) in enumerate(parts):
        py = 860 + i * 110
        draw_rounded_rect(draw, [40, py, w - 40, py + 95], 18, fill=(19, 27, 46), outline=(30, 41, 59))
        draw.text((65, py + 18), part, font=get_font(FONT_BOLD, 22), fill=(255, 255, 255))
        draw.text((w - 240, py + 18), status, font=get_font(FONT_BOLD, 18), fill=(56, 189, 248))
        # Progress Bar
        draw_rounded_rect(draw, [65, py + 58, w - 65, py + 72], 7, fill=(30, 41, 59))
        fill_w = int((w - 130) * pct)
        draw_rounded_rect(draw, [65, py + 58, 65 + fill_w, py + 72], 7, fill=(56, 189, 248))

    return img

def render_appliance_screen_4(w=960, h=1980):
    """High-Converting Paywall Screen"""
    img = Image.new("RGBA", (w, h), (8, 12, 20, 255))
    draw = ImageDraw.Draw(img)
    
    # Crown Badge
    draw.ellipse([w // 2 - 45, 100, w // 2 + 45, 190], fill=(56, 189, 248, 40), outline=(56, 189, 248), width=2)
    draw.text((w // 2 - 25, 125), "👑", font=get_font(FONT_BOLD, 40), fill=(255, 255, 255))
    
    draw.text((w // 2 - 180, 215), "Upgrade to Appliance Pro", font=get_font(FONT_BOLD, 36), fill=(255, 255, 255))
    draw.text((w // 2 - 220, 270), "⭐ 4.9/5 Rating · 18,000+ European Households", font=get_font(FONT_BOLD, 20), fill=(251, 191, 36))
    
    # Features Card
    draw_rounded_rect(draw, [40, 320, w - 40, 680], 24, fill=(19, 27, 46), outline=(30, 41, 59), width=2)
    feat_list = [
        ("Unlimited Appliance Vault", "Track unlimited devices (free tier capped at 10)"),
        ("Unlimited AI Receipt Scanning", "High-precision OCR without monthly scanning caps"),
        ("Gemini Multimodal Diagnostics", "Instant repair manuals and error code guidance"),
        ("Encrypted CloudKit Sync", "Seamless multi-device backup across iPhone, iPad, Mac")
    ]
    for i, (title, sub) in enumerate(feat_list):
        fy = 350 + i * 80
        draw.text((70, fy), "✓", font=get_font(FONT_BOLD, 26), fill=(56, 189, 248))
        draw.text((115, fy), title, font=get_font(FONT_BOLD, 24), fill=(255, 255, 255))
        draw.text((115, fy + 30), sub, font=get_font(FONT_REGULAR, 18), fill=(148, 163, 184))
        
    # Plan 1: Annual Hero Card
    draw_rounded_rect(draw, [40, 710, w - 40, 890], 24, fill=(19, 27, 46), outline=(56, 189, 248), width=3)
    # Badge
    draw_rounded_rect(draw, [70, 695, 340, 730], 12, fill=(249, 115, 22))
    draw.text((85, 702), "MOST POPULAR · SAVE 37%", font=get_font(FONT_BOLD, 18), fill=(255, 255, 255))
    draw.text((70, 755), "Annual Pro Pass", font=get_font(FONT_BOLD, 30), fill=(255, 255, 255))
    draw.text((70, 800), "7-Day Free Trial, then $2.49/mo (Just ₺41/ay)", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
    draw.text((w - 240, 755), "$29.99 / yr", font=get_font(FONT_BOLD, 30), fill=(56, 189, 248))
    draw.text((w - 180, 800), "₺499,99", font=get_font(FONT_BOLD, 22), fill=(148, 163, 184))

    # Plan 2: Monthly Decoy Card
    draw_rounded_rect(draw, [40, 920, w - 40, 1060], 24, fill=(15, 23, 42), outline=(30, 41, 59), width=2)
    draw.text((70, 955), "Monthly Pro Pass", font=get_font(FONT_BOLD, 28), fill=(255, 255, 255))
    draw.text((70, 995), "Flexible billing, cancel anytime", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
    draw.text((w - 240, 955), "$3.99 / mo", font=get_font(FONT_BOLD, 28), fill=(148, 163, 184))
    draw.text((w - 170, 995), "₺79,99", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))

    # Action CTA
    draw_rounded_rect(draw, [40, 1100, w - 40, 1190], 20, fill=(56, 189, 248))
    draw.text((w // 2 - 180, 1130), "Start 7-Day Free Trial", font=get_font(FONT_BOLD, 30), fill=(8, 12, 20))
    draw.text((w // 2 - 165, 1205), "🔒 No payment today · Cancel anytime in 1 tap", font=get_font(FONT_REGULAR, 18), fill=(148, 163, 184))

    return img

print("Screenshot generator engine initialized.")
