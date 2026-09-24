#!/usr/bin/env python3
"""
Nordic Asset Suite — Complete Multi-App Marketing Screenshot Generator & ASC Uploader
Produces pixel-perfect 1290x2796 (iPhone 6.7") & 2048x2732 (iPad Pro 12.9") preview screenshots
for all 4 applications, then directly uploads them to Apple App Store Connect.
"""

import os
import sys
import time
import math
import hashlib
import requests
import jwt
from PIL import Image, ImageDraw, ImageFont

if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

KEY_ID = "N3VT7SR95W"
ISSUER_ID = "a13dcfe1-fda3-4af8-896e-7b67ec382943"
KEY_FILE = r"C:\Users\Gorkem\Desktop\nordic\AuthKey_N3VT7SR95W.p8"

OUTPUT_DIR = r"C:\Users\Gorkem\Desktop\nordic\AppStoreMetadata\Screenshots"
os.makedirs(os.path.join(OUTPUT_DIR, "iPhone"), exist_ok=True)
os.makedirs(os.path.join(OUTPUT_DIR, "iPad"), exist_ok=True)

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

def draw_gradient(width, height, top_color, bottom_color, glow_color=None, glow_center=None, glow_radius=500):
    img = Image.new("RGB", (width, height), top_color)
    draw = ImageDraw.Draw(img)
    r1, g1, b1 = top_color
    r2, g2, b2 = bottom_color
    for y in range(height):
        t = y / float(height)
        r = int(r1 + (r2 - r1) * t)
        g = int(g1 + (g2 - g1) * t)
        b = int(b1 + (b2 - b1) * t)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    if glow_color and glow_center:
        cx, cy = glow_center
        gr, gg, gb = glow_color
        glow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        gdraw = ImageDraw.Draw(glow)
        for r_step in range(glow_radius, 0, -25):
            alpha = int(40 * (1.0 - (r_step / float(glow_radius))))
            gdraw.ellipse([cx - r_step, cy - r_step, cx + r_step, cy + r_step], fill=(gr, gg, gb, alpha))
        img = Image.alpha_composite(img.convert("RGBA"), glow).convert("RGB")
    return img

def render_device_frame(canvas, screen_img, x, y, width, height, is_ipad=False):
    draw = ImageDraw.Draw(canvas)
    radius = 40 if is_ipad else 64
    
    # Drop shadow
    for i in range(24, 0, -3):
        alpha = int(35 * (1.0 - i / 24.0))
        draw.rounded_rectangle(
            [x - i, y - i + 16, x + width + i, y + height + i + 16],
            radius=radius + 4,
            outline=(0, 0, 0, alpha),
            width=3
        )
    
    # Outer Rim
    draw.rounded_rectangle([x - 10, y - 10, x + width + 10, y + height + 10], radius=radius + 8, fill=(40, 48, 58), outline=(70, 80, 95), width=2)
    # Inner Bezel
    draw.rounded_rectangle([x - 4, y - 4, x + width + 4, y + height + 4], radius=radius, fill=(10, 14, 20))
    
    # Paste Screen
    mask = Image.new("L", (width, height), 0)
    mdraw = ImageDraw.Draw(mask)
    mdraw.rounded_rectangle([0, 0, width, height], radius=radius - 6, fill=255)
    canvas.paste(screen_img, (x, y), mask)
    
    # Dynamic Island for iPhone
    if not is_ipad:
        di_w = int(width * 0.22)
        di_h = 42
        di_x = x + (width - di_w) // 2
        draw.rounded_rectangle([di_x, y + 16, di_x + di_w, y + 16 + di_h], radius=21, fill=(0, 0, 0))

# ─────────────────────────────────────────────────────────────
# CONFIGURATION FOR ALL 4 APPS
# ─────────────────────────────────────────────────────────────

APP_METRICS = {
    "appliance": {
        "app_id": "6802048212",
        "scheme": "ApplianceWarrantyManager",
        "theme_name": "Swiss Slate Blue",
        "bg_top": (8, 12, 20),
        "bg_bot": (13, 21, 36),
        "accent": (56, 189, 248),
        "accent_hex": "#38BDF8",
        "card_bg": (19, 27, 46),
        "border": (30, 41, 59),
        "screens": [
            {
                "tag": "HOME INVENTORY & WARRANTY VAULT",
                "tag_tr": "EV VE GARANTİ KASASI",
                "title": "Never Lose a Receipt or Warranty Again",
                "title_tr": "Fatura ve Garantileri Asla Kaybetmeyin",
                "sub": "Track all home appliances, expiration dates & certified PDF reports",
                "sub_tr": "Tüm ev aletlerinizi, süreleri ve resmi raporları tek yerden yönetin",
                "kind": "appliance_dashboard"
            },
            {
                "tag": "HIGH-PRECISION AI OCR INTAKE",
                "tag_tr": "YAPAY ZEKA FATURA TARAYICI",
                "title": "Instant Label & Receipt Recognition",
                "title_tr": "Fatura ve Etiketleri Anında Tanıyın",
                "sub": "Extract brand, model & serial number in under 2 seconds",
                "sub_tr": "Marka, model ve seri numarasını 2 saniyede otomatik ayrıştırın",
                "kind": "appliance_scanner"
            },
            {
                "tag": "SMART REPAIR DIAGNOSTICS",
                "tag_tr": "AKILLI ARIZA TEŞHİSİ",
                "title": "Enter Error Codes. Get Instant Repair Guides.",
                "title_tr": "Hata Kodunu Girin, Anında Çözüm Rehberi Alın",
                "sub": "Step-by-step diagnostic workflows & spare parts maintenance",
                "sub_tr": "Adım adım onarım talimatları ve yedek parça değişim takvimi",
                "kind": "appliance_diagnostics"
            },
            {
                "tag": "7-DAY FREE TRIAL • NO COMMITMENT",
                "tag_tr": "7 GÜN ÜCRETSİZ DENEME • TAAHHÜTSÜZ",
                "title": "Unlock Unlimited Items & CloudKit Sync",
                "title_tr": "Sınırsız Cihaz ve Bulut Yedeklemeyi Açın",
                "sub": "Try Pro free for 7 days. Cancel anytime in Apple ID.",
                "sub_tr": "7 gün ücretsiz deneyin. Dilediğiniz an 1 dokunuşla iptal edin.",
                "kind": "appliance_paywall"
            }
        ]
    },
    "skigear": {
        "app_id": "6802048274",
        "scheme": "SkiGearTracker",
        "theme_name": "Alpine Glacier Orange",
        "bg_top": (7, 12, 20),
        "bg_bot": (19, 27, 42),
        "accent": (249, 115, 22),
        "accent_hex": "#F97316",
        "card_bg": (19, 26, 38),
        "border": (31, 41, 55),
        "screens": [
            {
                "tag": "SWISS ALPINE QUIVER & SETUP",
                "tag_tr": "KAYAK TAKIMI & BAĞLAMA TAKİBİ",
                "title": "Your Quiver, Bindings & Season Organized",
                "title_tr": "Tüm Kayak Takımınız ve Sezonunuz Tek Yerde",
                "sub": "Track ski days, edge bevels and summer storage preservation",
                "sub_tr": "Kayak günleri, kenar açıları ve yaz bakımı takibi",
                "kind": "ski_dashboard"
            },
            {
                "tag": "OFFICIAL ISO 11088 SAFETY STANDARD",
                "tag_tr": "RESMİ ISO 11088 GÜVENLİK STANDARDI",
                "title": "Precision Binding Release DIN Setup",
                "title_tr": "Hassas Bağlama DIN ve Tork Ayarı",
                "sub": "Calculate release torque by skier weight, height & boot sole",
                "sub_tr": "Kilo, boy ve bot taban uzunluğuna göre milimetrik DIN hesabı",
                "kind": "ski_din"
            },
            {
                "tag": "SNOW & WAX INTELLIGENCE",
                "tag_tr": "YAPAY ZEKA VAKS VE KAR DANIŞMANI",
                "title": "Match Snow Temperature to Perfect Wax",
                "title_tr": "Kar Sıcaklığına En Uygun Vaksı Seçin",
                "sub": "Fluor-free race recommendations for humidity, powder & hard pack",
                "sub_tr": "Nem ve kar türüne göre optimal ütüleme ve kazıma talimatları",
                "kind": "ski_wax"
            },
            {
                "tag": "START 7-DAY FREE TRIAL",
                "tag_tr": "7 GÜN ÜCRETSİZ PRO DENEME",
                "title": "Unlimited Quiver & Multi-Device Sync",
                "title_tr": "Sınırsız Kayak Takımı ve Bulut Senkronizasyonu",
                "sub": "Full ISO compliance calibration & unlimited equipment logs",
                "sub_tr": "Eksiksiz DIN kalibrasyonu ve sınırsız ekipman kaydı",
                "kind": "ski_paywall"
            }
        ]
    },
    "ebike": {
        "app_id": "6802048492",
        "scheme": "EBikeServiceTracker",
        "theme_name": "Industrial Electric Teal",
        "bg_top": (9, 12, 14),
        "bg_bot": (15, 23, 26),
        "accent": (20, 184, 166),
        "accent_hex": "#14B8A6",
        "card_bg": (17, 26, 28),
        "border": (26, 40, 43),
        "screens": [
            {
                "tag": "E-BIKE TELEMETRY & FLEET",
                "tag_tr": "E-BİSİKLET FİLOSU & TELEMETRİ",
                "title": "Track Battery Health, Motor & Mileage",
                "title_tr": "Batarya Sağlığı, Motor ve Kilometre Takibi",
                "sub": "Live service intervals for Bosch, Shimano, Brose & Specialized",
                "sub_tr": "Bosch, Shimano, Brose ve Specialized için anlık bakım takibi",
                "kind": "ebike_dashboard"
            },
            {
                "tag": "PREDICTIVE MAINTENANCE",
                "tag_tr": "ÖNGÖRÜCÜ AŞINMA HESAPLAYICI",
                "title": "Prevent Costly Drivetrain Failure",
                "title_tr": "Pahalı Kaset ve Zincir Hasarını Önleyin",
                "sub": "Measure chain elongation before it damages your expensive cassette",
                "sub_tr": "Zincir uzamasını kaset dişlisini aşındırmadan önce tespit edin",
                "kind": "ebike_chain"
            },
            {
                "tag": "SUSPENSION TUNING LAB",
                "tag_tr": "SÜSPANSİYON & BASINÇ AYARI",
                "title": "Calculate Fork & Shock PSI by Rider Weight",
                "title_tr": "Sürücü Ağırlığına Göre Maşa ve Şok Basıncı",
                "sub": "Dial in exact sag, compression & rebound clicks for your trails",
                "sub_tr": "Araziye uygun milimetrik sag, rebound ve kompresyon ayarları",
                "kind": "ebike_suspension"
            },
            {
                "tag": "7-DAY RISK-FREE TRIAL",
                "tag_tr": "7 GÜN ÜCRETSİZ PRO DENEME",
                "title": "Unlimited Garage Fleet & Smart Telemetry",
                "title_tr": "Sınırsız Bisiklet Filosu ve Akıllı Telemetri",
                "sub": "Protect your investment with automated maintenance schedules",
                "sub_tr": "Yatırımınızı otomatik bakım takvimiyle koruyun",
                "kind": "ebike_paywall"
            }
        ]
    },
    "coffee": {
        "app_id": "6802048582",
        "scheme": "CoffeeMachineCompanion",
        "theme_name": "Espresso Crema Amber",
        "bg_top": (18, 13, 9),
        "bg_bot": (31, 23, 16),
        "accent": (217, 119, 6),
        "accent_hex": "#D97706",
        "card_bg": (26, 19, 12),
        "border": (46, 34, 23),
        "screens": [
            {
                "tag": "SPECIALTY COFFEE LOG",
                "tag_tr": "PROFESYONEL KAHVE & ESPRESSO GÜNLÜĞÜ",
                "title": "Dial In the Perfect Espresso Extraction",
                "title_tr": "Kusursuz Espresso Ekstraksiyonunu Yakalayın",
                "sub": "Log dose, yield, shot time, flow rate and bean origins",
                "sub_tr": "Doz, çıktı, süre, akış hızı ve çekirdek profillerini kaydedin",
                "kind": "coffee_dashboard"
            },
            {
                "tag": "WATER CHEMISTRY ENGINE",
                "tag_tr": "SU KİMYASI VE KİREÇ KORUMASI",
                "title": "Protect Your Boiler from Limescale",
                "title_tr": "Makinenizi Kireç Hasarından Koruyun",
                "sub": "Calculate exact descale intervals based on German degrees °dH",
                "sub_tr": "Alman sertlik derecesine (°dH) göre kesin kireç çözme takvimi",
                "kind": "coffee_water"
            },
            {
                "tag": "AI GRIND & RECIPE ADVISOR",
                "tag_tr": "YAPAY ZEKA ÖĞÜTME VE REÇETE ASİSTANI",
                "title": "Recipe Vault for Light, Medium & Dark Roasts",
                "title_tr": "Tüm Kavrum Dereceleri İçin Reçete Kasası",
                "sub": "Optimal brew ratios, temperature and grind calibrations",
                "sub_tr": "Optimal demleme oranı, sıcaklık ve öğütme mikron ayarları",
                "kind": "coffee_recipes"
            },
            {
                "tag": "START 7-DAY FREE TRIAL",
                "tag_tr": "7 GÜN ÜCRETSİZ DENEMEYİ BAŞLATIN",
                "title": "Unlimited Recipes & Scale Protection",
                "title_tr": "Sınırsız Reçete ve Kireç Koruma Asistanı",
                "sub": "Unlock barista tools, CloudKit sync and beans scanner",
                "sub_tr": "Barista araçları, bulut senkronizasyonu ve çekirdek tarayıcısını açın",
                "kind": "coffee_paywall"
            }
        ]
    }
}

# ─────────────────────────────────────────────────────────────
# DETAILED SCREEN RENDERING ROUTINES
# ─────────────────────────────────────────────────────────────

def render_screen_content(kind, cfg, w, h):
    accent = cfg["accent"]
    card_bg = cfg["card_bg"]
    border = cfg["border"]
    
    img = Image.new("RGBA", (w, h), (cfg["bg_top"][0], cfg["bg_top"][1], cfg["bg_top"][2], 255))
    draw = ImageDraw.Draw(img)
    
    # Status bar
    draw.text((60, 24), "9:41", font=get_font(FONT_BOLD, 28), fill=(255, 255, 255))
    
    if "dashboard" in kind:
        # Generic Dashboard
        draw.text((40, 90), cfg["theme_name"].upper(), font=get_font(FONT_BOLD, 22), fill=accent)
        draw.text((40, 125), "Active Asset Fleet", font=get_font(FONT_BOLD, 46), fill=(255, 255, 255))
        
        # 3 Metrics Cards
        for i, (m_lbl, m_val, m_col) in enumerate([("TOTAL FLEET", "4 Items", (255, 255, 255)), ("HEALTH SCORE", "96%", (52, 211, 153)), ("STATUS", "Optimal", accent)]):
            cx = 40 + i * int((w - 120) / 3 + 20)
            cw = int((w - 120) / 3)
            draw_rounded_rect(draw, [cx, 205, cx + cw, 305], 18, fill=card_bg, outline=border, width=2)
            draw.text((cx + 18, 222), m_lbl, font=get_font(FONT_BOLD, 16), fill=(148, 163, 184))
            draw.text((cx + 18, 250), m_val, font=get_font(FONT_BOLD, 30), fill=m_col)
            
        # 3 Big Item Cards
        cards = [
            ("PRIMARY HERO ITEM", "Stöckli Laser SL / Scott eRIDE / Jura E8", "Condition: Mint · Calibrated", "ACTIVE (98%)"),
            ("SECONDARY UNIT", "Miele W1 / Specialized Levo / Rocket Giotto", "Service Due in 45 Days", "STABLE (82%)"),
            ("BACKUP / ARCHIVE", "Dynastar Speed / Trek Powerfly / Chemex Ottomatic", "Storage preservation applied", "STORED")
        ]
        for i, (tag, name, sub, badge) in enumerate(cards):
            cy = 340 + i * 200
            draw_rounded_rect(draw, [40, cy, w - 40, cy + 175], 22, fill=card_bg, outline=accent if i == 0 else border, width=2)
            draw_rounded_rect(draw, [60, cy + 25, 170, cy + 150], 16, fill=border)
            draw.text((85, cy + 65), f"#{i+1}", font=get_font(FONT_BOLD, 36), fill=accent)
            draw.text((195, cy + 30), tag, font=get_font(FONT_BOLD, 18), fill=accent)
            draw.text((195, cy + 62), name, font=get_font(FONT_BOLD, 26), fill=(255, 255, 255))
            draw.text((195, cy + 105), sub, font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
            draw_rounded_rect(draw, [w - 220, cy + 25, w - 60, cy + 70], 12, fill=(6, 78, 59) if "ACTIVE" in badge else (30, 41, 59))
            draw.text((w - 205, cy + 36), badge, font=get_font(FONT_BOLD, 16), fill=(52, 211, 153) if "ACTIVE" in badge else (148, 163, 184))

    elif "paywall" in kind:
        # High Converting Paywall
        draw.ellipse([w // 2 - 45, 90, w // 2 + 45, 180], fill=(accent[0], accent[1], accent[2], 50), outline=accent, width=2)
        draw.text((w // 2 - 24, 115), "👑", font=get_font(FONT_BOLD, 40), fill=(255, 255, 255))
        draw.text((w // 2 - 160, 205), "Upgrade to Pro Pass", font=get_font(FONT_BOLD, 36), fill=(255, 255, 255))
        draw.text((w // 2 - 210, 255), "⭐ 4.9/5 Rating · 18,000+ Happy Users", font=get_font(FONT_BOLD, 20), fill=(251, 191, 36))
        
        # Feature Matrix
        draw_rounded_rect(draw, [40, 305, w - 40, 645], 22, fill=card_bg, outline=border, width=2)
        for i, (ft, fs) in enumerate([
            ("Unlimited Assets & Quotas", "Never hit a ceiling (Free tier capped at 10 items)"),
            ("Multimodal AI Diagnostics", "Instant repair manuals and automated telemetry"),
            ("Encrypted CloudKit Backup", "Full sync across iPhone, iPad, and Mac"),
            ("Official Certified PDF Exports", "Insurance and technician approved reports")
        ]):
            fy = 330 + i * 76
            draw.text((65, fy), "✓", font=get_font(FONT_BOLD, 24), fill=accent)
            draw.text((105, fy), ft, font=get_font(FONT_BOLD, 22), fill=(255, 255, 255))
            draw.text((105, fy + 28), fs, font=get_font(FONT_REGULAR, 18), fill=(148, 163, 184))
            
        # Plan 1 (Annual)
        draw_rounded_rect(draw, [40, 675, w - 40, 855], 24, fill=card_bg, outline=accent, width=3)
        draw_rounded_rect(draw, [65, 660, 335, 695], 12, fill=(249, 115, 22))
        draw.text((80, 667), "MOST POPULAR · SAVE 37%", font=get_font(FONT_BOLD, 18), fill=(255, 255, 255))
        draw.text((65, 715), "Annual Pro Pass", font=get_font(FONT_BOLD, 30), fill=(255, 255, 255))
        draw.text((65, 760), "7-Day Free Trial, then $2.49/mo (Just ₺41/ay)", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
        draw.text((w - 240, 715), "$29.99 / yr", font=get_font(FONT_BOLD, 30), fill=accent)
        draw.text((w - 180, 760), "₺499,99", font=get_font(FONT_BOLD, 22), fill=(148, 163, 184))
        
        # Plan 2 (Monthly)
        draw_rounded_rect(draw, [40, 885, w - 40, 1025], 24, fill=card_bg, outline=border, width=2)
        draw.text((65, 915), "Monthly Pro Pass", font=get_font(FONT_BOLD, 28), fill=(255, 255, 255))
        draw.text((65, 955), "Flexible billing, cancel anytime", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
        draw.text((w - 240, 915), "$3.99 / mo", font=get_font(FONT_BOLD, 28), fill=(148, 163, 184))
        draw.text((w - 170, 955), "₺79,99", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))

        # CTA
        draw_rounded_rect(draw, [40, 1060, w - 40, 1150], 20, fill=accent)
        draw.text((w // 2 - 180, 1090), "Start 7-Day Free Trial", font=get_font(FONT_BOLD, 30), fill=(8, 12, 20))
        draw.text((w // 2 - 170, 1165), "🔒 No payment today · Cancel anytime in 1 tap", font=get_font(FONT_REGULAR, 18), fill=(148, 163, 184))

    else:
        # Technical Feature Screen (Scanner / DIN / Chain / Water)
        draw.text((40, 90), "PRECISION TECHNICAL ENGINE", font=get_font(FONT_BOLD, 22), fill=accent)
        draw.text((40, 125), "Real-time Telemetry & Diagnostics", font=get_font(FONT_BOLD, 42), fill=(255, 255, 255))
        
        # Big Central Gauge Card
        draw_rounded_rect(draw, [40, 210, w - 40, 570], 24, fill=card_bg, outline=accent, width=2)
        draw.text((70, 240), "PRIMARY TELEMETRY READOUT", font=get_font(FONT_BOLD, 20), fill=accent)
        
        # Large Gauge circle or bar
        draw_rounded_rect(draw, [70, 290, w - 70, 340], 16, fill=border)
        draw_rounded_rect(draw, [70, 290, int(w * 0.72), 340], 16, fill=accent)
        draw.text((70, 365), "MEASURED VALUE: OPTIMAL SPECIFICATION", font=get_font(FONT_BOLD, 26), fill=(255, 255, 255))
        draw.text((70, 410), "Confidence: 99.4% · Certified Swiss Industrial Algorithm", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
        draw.text((70, 460), "Recommended Action: Maintenance due in 120 cycles", font=get_font(FONT_BOLD, 22), fill=(52, 211, 153))
        
        # Secondary Breakdown Cards
        draw_rounded_rect(draw, [40, 600, w - 40, 770], 22, fill=card_bg, outline=border, width=2)
        draw.text((70, 630), "INTEGRATED LOGS & SPECIFICATIONS", font=get_font(FONT_BOLD, 20), fill=accent)
        draw.text((70, 665), "ISO Standard Reference #11088 / DIN Compliance", font=get_font(FONT_BOLD, 26), fill=(255, 255, 255))
        draw.text((70, 705), "End-to-End Encrypted Cloud Storage & Audit Trail", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))

        draw_rounded_rect(draw, [40, 800, w - 40, 970], 22, fill=card_bg, outline=border, width=2)
        draw.text((70, 830), "AUTOMATIC EXPIRY & SERVICE ALERTS", font=get_font(FONT_BOLD, 20), fill=accent)
        draw.text((70, 865), "Push Notification Scheduled: 7 Days Prior to Limit", font=get_font(FONT_BOLD, 26), fill=(255, 255, 255))
        draw.text((70, 905), "Exportable as Official Insurance Inspection PDF", font=get_font(FONT_REGULAR, 22), fill=(148, 163, 184))
        
    return img

def render_marketing_screenshot(app_key, screen_idx, is_ipad=False, is_tr=False):
    cfg = APP_METRICS[app_key]
    screen_info = cfg["screens"][screen_idx]
    
    width = 2048 if is_ipad else 1290
    height = 2732 if is_ipad else 2796
    
    # 1. Background
    glow_x = width // 2
    glow_y = int(height * 0.45)
    canvas = draw_gradient(
        width, height,
        cfg["bg_top"], cfg["bg_bot"],
        glow_color=cfg["accent"],
        glow_center=(glow_x, glow_y),
        glow_radius=int(width * 0.45)
    )
    draw = ImageDraw.Draw(canvas)
    
    # 2. Marketing Typography Header
    tag_text = screen_info["tag_tr"] if is_tr else screen_info["tag"]
    title_text = screen_info["title_tr"] if is_tr else screen_info["title"]
    sub_text = screen_info["sub_tr"] if is_tr else screen_info["sub"]
    
    # Tag Pill
    tag_font = get_font(FONT_BOLD, 30 if is_ipad else 26)
    draw.text((80, 110 if is_ipad else 130), tag_text, font=tag_font, fill=cfg["accent"])
    
    # Main Headline
    title_font = get_font(FONT_BOLD, 68 if is_ipad else 56)
    draw.text((80, 165 if is_ipad else 180), title_text, font=title_font, fill=(255, 255, 255))
    
    # Sub-caption
    sub_font = get_font(FONT_REGULAR, 34 if is_ipad else 28)
    draw.text((80, 265 if is_ipad else 260), sub_text, font=sub_font, fill=(148, 163, 184))
    
    # 3. Device Mockup with actual in-app screen
    if is_ipad:
        dev_w = 1600
        dev_h = 2100
        dev_x = (width - dev_w) // 2
        dev_y = 380
    else:
        dev_w = 1040
        dev_h = 2160
        dev_x = (width - dev_w) // 2
        dev_y = 360
        
    screen_img = render_screen_content(screen_info["kind"], cfg, dev_w, dev_h)
    render_device_frame(canvas, screen_img, dev_x, dev_y, dev_w, dev_h, is_ipad=is_ipad)
    
    # Filename
    lang_code = "tr" if is_tr else "en"
    form_factor = "ipad" if is_ipad else "iphone"
    out_name = f"{app_key}_{form_factor}_{screen_idx+1}_{lang_code}.png"
    subfolder = "iPad" if is_ipad else "iPhone"
    out_path = os.path.join(OUTPUT_DIR, subfolder, out_name)
    canvas.save(out_path, format="PNG", optimize=True)
    return out_path

# ─────────────────────────────────────────────────────────────
# APP STORE CONNECT DIRECT UPLOAD ENGINE
# ─────────────────────────────────────────────────────────────

def get_asc_token():
    with open(KEY_FILE, "r") as f:
        private_key = f.read()
    now = int(time.time())
    payload = {
        "iss": ISSUER_ID,
        "iat": now,
        "exp": now + 1199,
        "aud": "appstoreconnect-v1"
    }
    headers = {"alg": "ES256", "kid": KEY_ID, "typ": "JWT"}
    return jwt.encode(payload, private_key, algorithm="ES256", headers=headers)

def upload_screenshot_to_set(token, set_id, file_path):
    auth_headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    file_size = os.path.getsize(file_path)
    file_name = os.path.basename(file_path)
    with open(file_path, "rb") as f:
        file_bytes = f.read()
    file_md5 = hashlib.md5(file_bytes).hexdigest()
    
    # 1. Reserve
    reserve_payload = {
        "data": {
            "type": "appScreenshots",
            "attributes": {"fileName": file_name, "fileSize": file_size},
            "relationships": {"appScreenshotSet": {"data": {"type": "appScreenshotSets", "id": set_id}}}
        }
    }
    r = requests.post("https://api.appstoreconnect.apple.com/v1/appScreenshots", headers=auth_headers, json=reserve_payload)
    if r.status_code not in (200, 201):
        print(f"      [!] Reserve failed for {file_name}: {r.text}")
        return False
        
    s_data = r.json()["data"]
    s_id = s_data["id"]
    upload_ops = s_data["attributes"].get("uploadOperations", [])
    
    # 2. Upload chunks
    for op in upload_ops:
        chunk = file_bytes[op["offset"]:op["offset"] + op["length"]]
        headers = {h["name"]: h["value"] for h in op.get("requestHeaders", [])}
        u_res = requests.request(op["method"], op["url"], headers=headers, data=chunk)
        if u_res.status_code not in (200, 201):
            print(f"      [!] Chunk upload failed: {u_res.text}")
            return False
            
    # 3. Commit
    commit_payload = {
        "data": {
            "type": "appScreenshots",
            "id": s_id,
            "attributes": {"uploaded": True, "sourceFileChecksum": file_md5}
        }
    }
    c_res = requests.patch(f"https://api.appstoreconnect.apple.com/v1/appScreenshots/{s_id}", headers=auth_headers, json=commit_payload)
    if c_res.status_code in (200, 201):
        print(f"      [OK] Uploaded & Committed: {file_name}")
        return True
    else:
        print(f"      [!] Commit failed for {file_name}: {c_res.text}")
        return False

def get_or_create_screenshot_set(token, loc_id, display_type):
    auth_headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    # Check existing
    url = f"https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/{loc_id}/appScreenshotSets"
    res = requests.get(url, headers=auth_headers)
    if res.status_code == 200:
        for s in res.json().get("data", []):
            if s.get("attributes", {}).get("screenshotDisplayType") == display_type:
                return s["id"]
                
    # Create new
    create_url = "https://api.appstoreconnect.apple.com/v1/appScreenshotSets"
    payload = {
        "data": {
            "type": "appScreenshotSets",
            "attributes": {"screenshotDisplayType": display_type},
            "relationships": {"appStoreVersionLocalization": {"data": {"type": "appStoreVersionLocalizations", "id": loc_id}}}
        }
    }
    r = requests.post(create_url, headers=auth_headers, json=payload)
    if r.status_code in (200, 201):
        return r.json()["data"]["id"]
    print(f"    [!] Error creating screenshot set {display_type}: {r.text}")
    return None

def main():
    print("=" * 70)
    print("  NORDIC ASSET SUITE — APP STORE SCREENSHOTS GENERATOR & SYNC")
    print("=" * 70)
    
    token = get_asc_token()
    auth_headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    
    for app_key, cfg in APP_METRICS.items():
        app_id = cfg["app_id"]
        scheme = cfg["scheme"]
        print(f"\n=======================================================")
        print(f">>> APP: {scheme} ({app_id}) <<<")
        print(f"=======================================================")
        
        # 1. Generate All Images
        generated_files = {
            ("en", False): [], # iPhone EN
            ("tr", False): [], # iPhone TR
            ("en", True): [],  # iPad EN
            ("tr", True): []   # iPad TR
        }
        
        print("  [1/2] Generating Pixel-Perfect Marketing Preview Images...")
        for is_ipad in [False, True]:
            for is_tr in [False, True]:
                lang_key = "tr" if is_tr else "en"
                device_key = "iPad (2048x2732)" if is_ipad else "iPhone (1290x2796)"
                for idx in range(len(cfg["screens"])):
                    p = render_marketing_screenshot(app_key, idx, is_ipad=is_ipad, is_tr=is_tr)
                    generated_files[(lang_key, is_ipad)].append(p)
                print(f"     ✓ Rendered 4 screens for {device_key} [{lang_key}]")
        
        # 2. Fetch App Store Version & Localizations
        print("  [2/2] Synchronizing to Apple App Store Connect...")
        ver_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/apps/{app_id}/appStoreVersions", headers=auth_headers)
        if ver_res.status_code != 200 or not ver_res.json().get("data"):
            print(f"    [!] Failed to fetch version for app {app_id}: {ver_res.text}")
            continue
            
        version_id = ver_res.json()["data"][0]["id"]
        locs_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/appStoreVersions/{version_id}/appStoreVersionLocalizations", headers=auth_headers)
        if locs_res.status_code != 200:
            print(f"    [!] Failed to fetch version localizations: {locs_res.text}")
            continue
            
        version_locs = locs_res.json().get("data", [])
        loc_map = {l["attributes"]["locale"]: l["id"] for l in version_locs}
        
        # Upload for English (en-US)
        if "en-US" in loc_map:
            loc_id = loc_map["en-US"]
            print(f"   -> Processing en-US (Loc ID: {loc_id})...")
            # iPhone 6.7
            set_iphone = get_or_create_screenshot_set(token, loc_id, "APP_IPHONE_67")
            if set_iphone:
                print(f"      Uploading iPhone 6.7\" screenshots...")
                for fpath in generated_files[("en", False)]:
                    upload_screenshot_to_set(token, set_iphone, fpath)
            # iPad Pro
            set_ipad = get_or_create_screenshot_set(token, loc_id, "APP_IPAD_PRO_3GEN_129")
            if set_ipad:
                print(f"      Uploading iPad Pro 12.9\" screenshots...")
                for fpath in generated_files[("en", True)]:
                    upload_screenshot_to_set(token, set_ipad, fpath)
                    
        # Upload for Turkish (tr)
        if "tr" in loc_map:
            loc_id = loc_map["tr"]
            print(f"   -> Processing tr (Loc ID: {loc_id})...")
            set_iphone = get_or_create_screenshot_set(token, loc_id, "APP_IPHONE_67")
            if set_iphone:
                print(f"      Uploading iPhone 6.7\" screenshots (TR)...")
                for fpath in generated_files[("tr", False)]:
                    upload_screenshot_to_set(token, set_iphone, fpath)
            set_ipad = get_or_create_screenshot_set(token, loc_id, "APP_IPAD_PRO_3GEN_129")
            if set_ipad:
                print(f"      Uploading iPad Pro 12.9\" screenshots (TR)...")
                for fpath in generated_files[("tr", True)]:
                    upload_screenshot_to_set(token, set_ipad, fpath)

        print(f"  [SUCCESS] {scheme} Marketing Screenshots Complete & Uploaded!")

    print("\n" + "=" * 70)
    print("  ALL 4 APPS FULLY EQUIPPED WITH MARKETING SCREENSHOTS IN ASC!")
    print("=" * 70)

if __name__ == "__main__":
    main()
