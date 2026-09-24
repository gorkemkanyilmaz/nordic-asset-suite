import os
import json
import math
from PIL import Image, ImageDraw, ImageFilter

def create_gradient(size, start_rgb, end_rgb, direction="vertical"):
    img = Image.new("RGB", (size, size), start_rgb)
    draw = ImageDraw.Draw(img)
    for i in range(size):
        ratio = i / float(size)
        r = int(start_rgb[0] * (1 - ratio) + end_rgb[0] * ratio)
        g = int(start_rgb[1] * (1 - ratio) + end_rgb[1] * ratio)
        b = int(start_rgb[2] * (1 - ratio) + end_rgb[2] * ratio)
        draw.line([(0, i), (size, i)], fill=(r, g, b))
    return img

# =========================================================================
# APP 1: APPLIANCE WARRANTY MANAGER (Retain the praised Vault Shield)
# =========================================================================
def render_appliance_icon(size=2048):
    bg = create_gradient(size, (10, 18, 38), (18, 36, 74), "vertical")
    
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    for r in range(size // 2, 0, -10):
        alpha = int((1 - (r / (size // 2))) * 40)
        glow_draw.ellipse([size // 2 - r, size // 3 - r, size // 2 + r, size // 3 + r], fill=(56, 189, 248, alpha))
    bg.paste(glow, (0, 0), glow)
    
    draw = ImageDraw.Draw(bg, "RGBA")
    cx, cy = size // 2, size // 2 + 30
    w, h = 480, 560
    
    shield_pts = [
        (cx, cy - h + 100),
        (cx + w, cy - h + 180),
        (cx + w - 40, cy + 140),
        (cx, cy + h - 80),
        (cx - w + 40, cy + 140),
        (cx - w, cy - h + 180)
    ]
    draw.polygon(shield_pts, fill=(14, 165, 233, 40))
    
    inner_pts = [
        (cx, cy - h + 130),
        (cx + w - 35, cy - h + 200),
        (cx + w - 70, cy + 120),
        (cx, cy + h - 120),
        (cx - w + 70, cy + 120),
        (cx - w + 35, cy - h + 200)
    ]
    draw.polygon(inner_pts, fill=(2, 132, 199, 230), outline=(56, 189, 248, 255), width=24)
    
    house_pts = [
        (cx, cy - 180),
        (cx + 200, cy - 20),
        (cx + 140, cy - 20),
        (cx + 140, cy + 180),
        (cx - 140, cy + 180),
        (cx - 140, cy - 20),
        (cx - 200, cy - 20)
    ]
    draw.polygon(house_pts, fill=(255, 255, 255, 255))
    
    chk = [
        (cx - 60, cy + 70),
        (cx - 10, cy + 120),
        (cx + 70, cy + 20)
    ]
    draw.line(chk, fill=(2, 132, 199, 255), width=32, joint="curve")
    draw.rounded_rectangle([cx - 120, cy + 320, cx + 120, cy + 338], radius=9, fill=(56, 189, 248, 180))
    return bg

# =========================================================================
# APP 2: COFFEE MACHINE COMPANION
# PURPOSE: Precision Espresso Machine & Barista Dial-In / Descaling Companion
# ICON HERO: Authentic Precision Barista Portafilter, 9-Bar Gauge & Golden Crema Extraction
# =========================================================================
def render_coffee_icon(size=2048):
    # Deep Roasted Espresso Obsidian
    bg = create_gradient(size, (18, 12, 9), (34, 22, 16), "vertical")
    
    # Warm Amber Radial Glow
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    for r in range(size // 2, 0, -10):
        alpha = int((1 - (r / (size // 2))) * 50)
        glow_draw.ellipse([size // 2 - r, size // 2 - r - 80, size // 2 + r, size // 2 + r - 80], fill=(245, 158, 11, alpha))
    bg.paste(glow, (0, 0), glow)
    
    draw = ImageDraw.Draw(bg, "RGBA")
    cx, cy = size // 2, size // 2 - 40
    
    # 1. Background: Concentric 9-Bar Extraction Pressure Gauge Arc
    gauge_r = 540
    draw.arc([cx - gauge_r, cy - gauge_r, cx + gauge_r, cy + gauge_r], start=140, end=400, fill=(245, 158, 11, 70), width=14)
    # 9-Bar Target Segment (The Espresso Sweet Spot)
    draw.arc([cx - gauge_r, cy - gauge_r, cx + gauge_r, cy + gauge_r], start=240, end=300, fill=(245, 158, 11, 230), width=24)
    # Gauge calibration ticks
    for deg in range(150, 395, 20):
        rad = math.radians(deg)
        x1 = cx + (gauge_r - 25) * math.cos(rad)
        y1 = cy + (gauge_r - 25) * math.sin(rad)
        x2 = cx + (gauge_r + 25) * math.cos(rad)
        y2 = cy + (gauge_r + 25) * math.sin(rad)
        tick_col = (255, 255, 255, 200) if (240 <= deg <= 300) else (245, 158, 11, 100)
        draw.line([(x1, y1), (x2, y2)], fill=tick_col, width=8)

    # 2. Hero: Precision Stainless Steel Barista Portafilter
    # Group Head / Portafilter Basket Rim (Top circular collar)
    head_w, head_h = 320, 220
    
    # Portafilter Locking Ears (Left & Right lugs)
    ear_w, ear_h = 70, 44
    draw.rounded_rectangle([cx - head_w - ear_w + 20, cy - 40, cx - head_w + 30, cy + ear_h - 40], radius=16, fill=(203, 213, 225, 255), outline=(255, 255, 255, 255), width=6)
    draw.rounded_rectangle([cx + head_w - 30, cy - 40, cx + head_w + ear_w - 20, cy + ear_h - 40], radius=16, fill=(203, 213, 225, 255), outline=(255, 255, 255, 255), width=6)

    # Stainless Portafilter Cup Body (Chrome basket housing)
    basket_pts = [
        (cx - head_w + 10, cy - 60),
        (cx + head_w - 10, cy - 60),
        (cx + head_w - 50, cy + 160),
        (cx - head_w + 50, cy + 160)
    ]
    # Brushed Chrome Body
    draw.polygon(basket_pts, fill=(241, 245, 249, 255), outline=(255, 255, 255, 255), width=10)
    
    # Top rim / precision basket surface (Dark rich roast bed visible)
    draw.ellipse([cx - head_w + 10, cy - 100, cx + head_w - 10, cy - 20], fill=(226, 232, 240, 255), outline=(255, 255, 255, 255), width=8)
    # Ground Espresso Puck Surface
    draw.ellipse([cx - head_w + 40, cy - 90, cx + head_w - 40, cy - 30], fill=(62, 39, 35, 255))
    draw.ellipse([cx - head_w + 70, cy - 80, cx + head_w - 70, cy - 40], fill=(217, 119, 6, 200)) # Golden Crema sheen on puck

    # Dual Chrome Extraction Spouts Below Basket
    # Spout block
    draw.rounded_rectangle([cx - 90, cy + 150, cx + 90, cy + 220], radius=18, fill=(203, 213, 225, 255), outline=(255, 255, 255, 255), width=6)
    # Left spout curve
    draw.polygon([(cx - 70, cy + 200), (cx - 90, cy + 270), (cx - 45, cy + 270), (cx - 35, cy + 200)], fill=(226, 232, 240, 255))
    # Right spout curve
    draw.polygon([(cx + 35, cy + 200), (cx + 45, cy + 270), (cx + 90, cy + 270), (cx + 70, cy + 200)], fill=(226, 232, 240, 255))

    # 3. Barista Ergonomic Handle (Extending Straight Down with Walnut Texture & Stainless Cap)
    handle_top = cy + 220
    handle_bottom = cy + 720
    handle_w = 64
    
    # Stainless Steel Neck Collar
    draw.rounded_rectangle([cx - handle_w - 8, handle_top + 10, cx + handle_w + 8, handle_top + 70], radius=14, fill=(241, 245, 249, 255), outline=(255, 255, 255, 255), width=6)
    
    # Walnut Barista Handle Body (Tapered ergonomic luxury shape)
    handle_pts = [
        (cx - handle_w, handle_top + 60),
        (cx + handle_w, handle_top + 60),
        (cx + handle_w + 14, handle_bottom - 60),
        (cx - handle_w - 14, handle_bottom - 60)
    ]
    draw.polygon(handle_pts, fill=(58, 36, 28, 255), outline=(245, 158, 11, 140), width=6)
    # Subtle Woodgrain / Ergonomic Grip Highlight
    draw.line([(cx - 10, handle_top + 80), (cx - 10, handle_bottom - 80)], fill=(245, 158, 11, 80), width=12)
    # Polished Stainless Steel End Cap
    draw.rounded_rectangle([cx - handle_w - 6, handle_bottom - 70, cx + handle_w + 6, handle_bottom], radius=24, fill=(241, 245, 249, 255), outline=(255, 255, 255, 255), width=6)

    # 4. The Golden Extraction (Velvety Crema Espresso Droplet - Extraction in Action)
    drop_cx, drop_cy = cx, cy + 340
    # Teardrop shape
    drop_pts = [
        (drop_cx, drop_cy - 70),          # Sharp top point connecting to spout
        (drop_cx + 42, drop_cy + 10),      # Right swell
        (drop_cx + 30, drop_cy + 60),      # Bottom right
        (drop_cx, drop_cy + 75),           # Bottom round tip
        (drop_cx - 30, drop_cy + 60),      # Bottom left
        (drop_cx - 42, drop_cy + 10)       # Left swell
    ]
    draw.polygon(drop_pts, fill=(245, 158, 11, 255), outline=(255, 255, 255, 240), width=6)
    # Inner Crema Glow
    draw.ellipse([drop_cx - 16, drop_cy + 10, drop_cx + 16, drop_cy + 52], fill=(251, 191, 36, 255))
    
    return bg

# =========================================================================
# APP 3: E-BIKE SERVICE TRACKER
# PURPOSE: High-Performance Garage, Motor Diagnostics, Battery Telemetry & Chain Wear
# ICON HERO: Sleek Modern E-Bike Silhouette with Illuminated Battery Tube & Mid-Drive Motor
# =========================================================================
def render_ebike_icon(size=2048):
    # Dark Titanium Carbon Gradient
    bg = create_gradient(size, (14, 17, 23), (24, 30, 42), "vertical")
    
    # Electric Amber Ambient Halo
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    for r in range(size // 2, 0, -10):
        alpha = int((1 - (r / (size // 2))) * 45)
        glow_draw.ellipse([size // 2 - r, size // 2 - r, size // 2 + r, size // 2 + r], fill=(249, 115, 22, alpha))
    bg.paste(glow, (0, 0), glow)
    
    draw = ImageDraw.Draw(bg, "RGBA")
    cx, cy = size // 2, size // 2 + 60
    
    # Wheel Geometry
    wheel_r = 380
    rear_cx = cx - 520
    rear_cy = cy + 180
    front_cx = cx + 520
    front_cy = cy + 180
    
    # 1. Wheels (Aerodynamic Deep Carbon Rims with Spoke Geometry)
    for w_cx, w_cy in [(rear_cx, rear_cy), (front_cx, front_cy)]:
        # Outer Tire Tread
        draw.ellipse([w_cx - wheel_r, w_cy - wheel_r, w_cx + wheel_r, w_cy + wheel_r], fill=(30, 37, 48, 255), outline=(15, 23, 42, 255), width=18)
        # Carbon Aero Rim
        rim_r = wheel_r - 40
        draw.ellipse([w_cx - rim_r, w_cy - rim_r, w_cx + rim_r, w_cy + rim_r], fill=(15, 19, 26, 255), outline=(248, 250, 252, 255), width=22)
        # Inner Disc Brake Rotor (Precision Slotted)
        disc_r = 130
        draw.ellipse([w_cx - disc_r, w_cy - disc_r, w_cx + disc_r, w_cy + disc_r], fill=(30, 41, 59, 200), outline=(249, 115, 22, 200), width=8)
        # Center Axle Hub
        draw.ellipse([w_cx - 40, w_cy - 40, w_cx + 40, w_cy + 40], fill=(248, 250, 252, 255))
        # Sleek 4-Blade Aero Carbon Spokes
        for angle_deg in [0, 90, 180, 270]:
            rad = math.radians(angle_deg)
            sx = w_cx + (rim_r - 20) * math.cos(rad)
            sy = w_cy + (rim_r - 20) * math.sin(rad)
            draw.line([(w_cx, w_cy), (sx, sy)], fill=(203, 213, 225, 200), width=14)

    # 2. Key Frame Points
    bb_x, bb_y = cx - 80, rear_cy       # Mid-drive motor bottom bracket
    seat_j_x, seat_j_y = cx - 180, cy - 140  # Seat tube & top tube junction
    head_j_x, head_j_y = cx + 340, cy - 240  # Head tube top
    head_low_x, head_low_y = cx + 290, cy - 90 # Head tube bottom
    
    # 3. Rear Triangle (Chain Stay & Seat Stay)
    # Chain Stay (Rear wheel to Motor)
    draw.line([(rear_cx, rear_cy), (bb_x, bb_y)], fill=(248, 250, 252, 255), width=28)
    # Seat Stay (Rear wheel to Seat Junction)
    draw.line([(rear_cx, rear_cy), (seat_j_x, seat_j_y)], fill=(248, 250, 252, 255), width=24)
    # Seat Tube (Motor BB to Seat Junction)
    draw.line([(bb_x, bb_y), (seat_j_x, seat_j_y)], fill=(248, 250, 252, 255), width=32)

    # 4. Front Fork (Front Axle to Head Tube)
    draw.line([(front_cx, front_cy), (head_low_x, head_low_y)], fill=(248, 250, 252, 255), width=32)
    # Head Tube
    draw.line([(head_low_x, head_low_y), (head_j_x, head_j_y)], fill=(248, 250, 252, 255), width=38)

    # 5. Top Tube (Seat Junction to Head Tube - Aggressive Modern Sloping Geometry)
    draw.line([(seat_j_x, seat_j_y), (head_j_x, head_j_y)], fill=(248, 250, 252, 255), width=32)

    # 6. E-BIKE SIGNATURE HERO: Thick Integrated Battery Down Tube (Glowing Amber Telemetry)
    # The down-tube on an e-bike is thick, muscular, housing the lithium pack
    battery_pts = [
        (head_low_x - 10, head_low_y - 20),
        (head_low_x + 35, head_low_y + 10),
        (bb_x + 55, bb_y - 40),
        (bb_x + 5, bb_y - 80)
    ]
    draw.polygon(battery_pts, fill=(249, 115, 22, 255), outline=(255, 255, 255, 255), width=8)
    # Illuminated Power Cells inside Down Tube (Battery Life / Health Indicator)
    draw.line([(head_low_x + 12, head_low_y), (bb_x + 30, bb_y - 60)], fill=(255, 255, 255, 240), width=16)

    # 7. Mid-Drive Motor Unit at BB (Circular Power Drive Housing with Cooling Fins)
    motor_r = 100
    draw.ellipse([bb_x - motor_r, bb_y - motor_r, bb_x + motor_r, bb_y + motor_r], fill=(30, 41, 59, 255), outline=(249, 115, 22, 255), width=14)
    # Inner Electric Lightning Core
    bolt_pts = [
        (bb_x + 15, bb_y - 50),
        (bb_x - 30, bb_y + 5),
        (bb_x + 5, bb_y + 5),
        (bb_x - 15, bb_y + 50),
        (bb_x + 35, bb_y - 5),
        (bb_x + 5, bb_y - 5)
    ]
    draw.polygon(bolt_pts, fill=(249, 115, 22, 255))
    # Pedal Crank Arm
    draw.line([(bb_x, bb_y), (bb_x + 40, bb_y + 80)], fill=(248, 250, 252, 255), width=18)
    draw.rounded_rectangle([bb_x + 25, bb_y + 75, bb_x + 75, bb_y + 95], radius=6, fill=(249, 115, 22, 255))

    # 8. Handlebars, Stem, Seatpost & Saddle
    # Stem & Handlebars
    draw.line([(head_j_x, head_j_y), (head_j_x + 30, head_j_y - 80)], fill=(248, 250, 252, 255), width=24)
    draw.rounded_rectangle([head_j_x - 10, head_j_y - 95, head_j_x + 90, head_j_y - 70], radius=8, fill=(248, 250, 252, 255))
    # Seatpost & Sport Saddle
    draw.line([(seat_j_x, seat_j_y), (seat_j_x - 40, seat_j_y - 120)], fill=(248, 250, 252, 255), width=22)
    saddle_pts = [
        (seat_j_x - 120, seat_j_y - 130),
        (seat_j_x + 30, seat_j_y - 130),
        (seat_j_x + 20, seat_j_y - 105),
        (seat_j_x - 110, seat_j_y - 105)
    ]
    draw.polygon(saddle_pts, fill=(249, 115, 22, 255), outline=(248, 250, 252, 255), width=6)
    
    return bg

# =========================================================================
# APP 4: SKI GEAR TRACKER
# PURPOSE: Alpine Ski Quiver, ISO 11088 DIN Binding Safety, Waxing & Edge Tuning
# ICON HERO: High-Performance Crossed Alpine Skis with Prominent DIN Safety Bindings & Edges
# =========================================================================
def render_skigear_icon(size=2048):
    # Deep Alpine Glacial Slate
    bg = create_gradient(size, (11, 20, 36), (18, 34, 58), "vertical")
    
    # Glacial Cyan Radial Aura
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    for r in range(size // 2, 0, -10):
        alpha = int((1 - (r / (size // 2))) * 45)
        glow_draw.ellipse([size // 2 - r, size // 2 - r, size // 2 + r, size // 2 + r], fill=(56, 189, 248, alpha))
    bg.paste(glow, (0, 0), glow)
    
    draw = ImageDraw.Draw(bg, "RGBA")
    cx, cy = size // 2, size // 2
    
    # Background: Subtle Minimalist Twin Alpine Mountain Ridge (Depth backdrop)
    bg_ridge = [
        (cx - 700, cy + 600),
        (cx - 250, cy + 220),
        (cx + 100, cy + 420),
        (cx + 420, cy + 180),
        (cx + 700, cy + 600)
    ]
    draw.polygon(bg_ridge, fill=(14, 116, 144, 70), outline=(56, 189, 248, 80), width=6)

    # Function to draw a complete high-performance alpine ski with bindings
    def draw_alpine_ski(angle_deg, is_foreground=False):
        # We draw the ski vertically in an isolated canvas and rotate it with high quality
        ski_img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        s_draw = ImageDraw.Draw(ski_img)
        
        scx = size // 2
        length = 1540
        top_y = cy - length // 2
        bot_y = cy + length // 2
        
        tip_w = 75      # Shovel / Spatula width
        waist_w = 54    # Narrow carve waist
        tail_w = 68     # Tail width
        
        # 1. Outer Steel Carving Edge (Full contour)
        edge_pts = [
            # Tip apex (curved rockered shovel)
            (scx, top_y),
            (scx + tip_w, top_y + 110),
            (scx + tip_w - 6, top_y + 350),
            (scx + waist_w, cy),             # Narrow carving waist
            (scx + tail_w - 6, bot_y - 280),
            (scx + tail_w, bot_y - 50),
            (scx, bot_y),                    # Tail apex
            (scx - tail_w, bot_y - 50),
            (scx - tail_w + 6, bot_y - 280),
            (scx - waist_w, cy),
            (scx - tip_w + 6, top_y + 350),
            (scx - tip_w, top_y + 110)
        ]
        # Base body: Glacial Azure Racing Top-Sheet
        top_color = (2, 132, 199, 255) if is_foreground else (14, 116, 144, 255)
        s_draw.polygon(edge_pts, fill=top_color, outline=(255, 255, 255, 255), width=12)
        
        # 2. Racing Pinstripes & Speed Channel
        s_draw.line([(scx, top_y + 140), (scx, bot_y - 70)], fill=(56, 189, 248, 230), width=16)
        s_draw.line([(scx - 18, top_y + 200), (scx - 18, bot_y - 120)], fill=(255, 255, 255, 140), width=6)
        s_draw.line([(scx + 18, top_y + 200), (scx + 18, bot_y - 120)], fill=(255, 255, 255, 140), width=6)

        # 3. Metallic Tip & Tail Protectors
        # Spatula tip protector (stark white / chrome)
        s_draw.polygon([(scx, top_y), (scx + tip_w - 10, top_y + 70), (scx - tip_w + 10, top_y + 70)], fill=(255, 255, 255, 255))
        # Tail protector
        s_draw.polygon([(scx, bot_y), (scx + tail_w - 10, bot_y - 50), (scx - tail_w + 10, bot_y - 50)], fill=(255, 255, 255, 255))

        # 4. GEAR HERO: Mounted ISO 11088 DIN Safety Binding System (Toe & Heel Units)
        # Mounting Base Plate (Under boot)
        plate_w = waist_w + 14
        plate_top = cy - 220
        plate_bot = cy + 220
        s_draw.rounded_rectangle([scx - plate_w, plate_top, scx + plate_w, plate_bot], radius=16, fill=(15, 23, 42, 255), outline=(56, 189, 248, 255), width=8)

        # Front Toe Piece Housing (DIN Spring & Release Cam)
        toe_y = cy - 130
        toe_w = plate_w - 6
        toe_pts = [
            (scx - toe_w, toe_y - 65),
            (scx + toe_w, toe_y - 65),
            (scx + toe_w - 8, toe_y + 40),
            (scx - toe_w + 8, toe_y + 40)
        ]
        s_draw.polygon(toe_pts, fill=(56, 189, 248, 255), outline=(255, 255, 255, 255), width=6)
        # DIN Indicator Window on Toe
        s_draw.rounded_rectangle([scx - 16, toe_y - 45, scx + 16, toe_y - 5], radius=6, fill=(249, 115, 22, 255)) # Safety Orange DIN marker

        # Rear Heel Piece Housing (Step-in Lever & Lateral Release)
        heel_y = cy + 130
        heel_w = plate_w - 4
        heel_pts = [
            (scx - heel_w + 8, heel_y - 40),
            (scx + heel_w - 8, heel_y - 40),
            (scx + heel_w, heel_y + 65),
            (scx - heel_w, heel_y + 65)
        ]
        s_draw.polygon(heel_pts, fill=(248, 250, 252, 255), outline=(56, 189, 248, 255), width=6)
        # Heel Step-in Release Lever
        s_draw.rounded_rectangle([scx - 18, heel_y + 55, scx + 18, heel_y + 110], radius=8, fill=(249, 115, 22, 255), outline=(255, 255, 255, 255), width=4)

        # Rotated onto main canvas
        rotated = ski_img.rotate(angle_deg, resample=Image.Resampling.BICUBIC, center=(cx, cy))
        return rotated

    # Draw Ski 1 (Crossing from bottom-left to top-right: -28 degrees)
    ski1 = draw_alpine_ski(-28, is_foreground=False)
    bg.paste(ski1, (0, 0), ski1)

    # Draw Ski 2 (Crossing from bottom-right to top-left: +28 degrees, in foreground)
    ski2 = draw_alpine_ski(28, is_foreground=True)
    bg.paste(ski2, (0, 0), ski2)

    # Central Nexus Accent: Alpine Snowflake / Temperature Waxing & DIN Release Core
    center_glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    cg_draw = ImageDraw.Draw(center_glow)
    cg_draw.ellipse([cx - 160, cy - 160, cx + 160, cy + 160], fill=(2, 132, 199, 200), outline=(255, 255, 255, 255), width=10)
    # Snowflake / Precision Wax Crystal Cross
    for ang in [0, 60, 120]:
        rad = math.radians(ang)
        dx = 110 * math.cos(rad)
        dy = 110 * math.sin(rad)
        cg_draw.line([(cx - dx, cy - dy), (cx + dx, cy + dy)], fill=(255, 255, 255, 255), width=14)
        # Branch ticks
        for b_dist in [65]:
            bx = b_dist * math.cos(rad)
            by = b_dist * math.sin(rad)
            perp_rad = rad + math.pi / 2
            p_dx = 28 * math.cos(perp_rad)
            p_dy = 28 * math.sin(perp_rad)
            cg_draw.line([(cx + bx - p_dx, cy + by - p_dy), (cx + bx + p_dx, cy + by + p_dy)], fill=(56, 189, 248, 255), width=8)
            cg_draw.line([(cx - bx - p_dx, cy - by - p_dy), (cx - bx + p_dx, cy - by + p_dy)], fill=(56, 189, 248, 255), width=8)

    bg.paste(center_glow, (0, 0), center_glow)

    return bg

# =========================================================================
# GENERATE ALL & EXPORT TO MASTER XCASSETS & WEB-DEMO
# =========================================================================
def generate_all_icons_v2():
    base_dir = r"c:\Users\Gorkem\Desktop\nordic"
    renderers = {
        "ApplianceWarrantyManager": render_appliance_icon,
        "CoffeeMachineCompanion": render_coffee_icon,
        "EBikeServiceTracker": render_ebike_icon,
        "SkiGearTracker": render_skigear_icon
    }
    
    web_icons_dir = os.path.join(base_dir, "web-demo", "public", "icons")
    dist_icons_dir = os.path.join(base_dir, "web-demo", "dist", "icons")
    os.makedirs(web_icons_dir, exist_ok=True)
    os.makedirs(dist_icons_dir, exist_ok=True)

    app_keys = {
        "ApplianceWarrantyManager": "appliance",
        "CoffeeMachineCompanion": "coffee",
        "EBikeServiceTracker": "ebike",
        "SkiGearTracker": "skigear"
    }

    for app_name, renderer in renderers.items():
        print(f"Rendering high-precision 2048px canvas for {app_name}...")
        high_res = renderer(2048)
        
        # 1. Native Xcode Universal Single-Size 1024x1024 master icon
        icon_1024 = high_res.resize((1024, 1024), Image.Resampling.LANCZOS)
        
        target_dir = os.path.join(base_dir, app_name, "Assets.xcassets", "AppIcon.appiconset")
        os.makedirs(target_dir, exist_ok=True)
        
        out_path = os.path.join(target_dir, "AppIcon-1024.png")
        icon_1024.save(out_path, "PNG", optimize=True)
        
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

        # 2. Export 180x180 and 512x512 web icons
        k = app_keys[app_name]
        icon_180 = high_res.resize((180, 180), Image.Resampling.LANCZOS)
        icon_180.save(os.path.join(web_icons_dir, f"{k}-icon-180.png"), "PNG", optimize=True)
        icon_180.save(os.path.join(dist_icons_dir, f"{k}-icon-180.png"), "PNG", optimize=True)

        icon_512 = high_res.resize((512, 512), Image.Resampling.LANCZOS)
        icon_512.save(os.path.join(web_icons_dir, f"{k}-icon-512.png"), "PNG", optimize=True)
        icon_512.save(os.path.join(dist_icons_dir, f"{k}-icon-512.png"), "PNG", optimize=True)

    print("All master and web icons successfully re-rendered and synced!")

if __name__ == "__main__":
    generate_all_icons_v2()
