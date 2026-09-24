import time
import jwt
import requests
import json
import sys

if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

KEY_ID = "N3VT7SR95W"
ISSUER_ID = "a13dcfe1-fda3-4af8-896e-7b67ec382943"
KEY_FILE = r"C:\Users\Gorkem\Desktop\nordic\AuthKey_N3VT7SR95W.p8"

with open(KEY_FILE, "r") as f:
    private_key = f.read()

now = int(time.time())
payload = {"iss": ISSUER_ID, "iat": now, "exp": now + 600, "aud": "appstoreconnect-v1"}
headers = {"alg": "ES256", "kid": KEY_ID, "typ": "JWT"}
token = jwt.encode(payload, private_key, algorithm="ES256", headers=headers)
auth_headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

apps = [
    ("6802048212", "Appliance Warranty Manager"),
    ("6802048274", "Ski & Snowboard Gear Tuning"),
    ("6802048492", "E-Bike Service & Maintenance"),
    ("6802048582", "Coffee Brew & Espresso Log")
]

print("=" * 70)
print("  APP STORE CONNECT — SCREENSHOT SETS & ASSETS AUDIT")
print("=" * 70)

for app_id, app_name in apps:
    print(f"\n📦 {app_name} ({app_id})")
    ver_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/apps/{app_id}/appStoreVersions", headers=auth_headers)
    if ver_res.status_code == 200:
        version_id = ver_res.json()["data"][0]["id"]
        locs_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/appStoreVersions/{version_id}/appStoreVersionLocalizations", headers=auth_headers)
        if locs_res.status_code == 200:
            for l in locs_res.json().get("data", []):
                locale = l["attributes"]["locale"]
                if locale in ("en-US", "tr"):
                    loc_id = l["id"]
                    sets_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/{loc_id}/appScreenshotSets", headers=auth_headers)
                    if sets_res.status_code == 200:
                        sets = sets_res.json().get("data", [])
                        print(f"   🌐 Locale: {locale} -> {len(sets)} Screenshot Sets:")
                        for s in sets:
                            dtype = s["attributes"]["screenshotDisplayType"]
                            sid = s["id"]
                            # Get count of screenshots in this set
                            ss_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/appScreenshotSets/{sid}/appScreenshots", headers=auth_headers)
                            count = len(ss_res.json().get("data", [])) if ss_res.status_code == 200 else 0
                            print(f"      • {dtype}: {count} screenshots committed")
    print("-" * 50)
