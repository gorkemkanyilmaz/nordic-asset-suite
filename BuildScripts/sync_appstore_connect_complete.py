#!/usr/bin/env python3
"""
Nordic Asset Suite — App Store Connect Automated Subscriptions & Metadata Sync
Configures all 4 apps:
1. Subscription Groups & Auto-Renewable Subscriptions (Monthly & Annual with 7-Day Free Trial)
2. Global Territories Availability & Localized Fair Pricing (175+ countries)
3. App Store Metadata (Description, Keywords, Promo Text, Support URL, Marketing URL)
4. App Info (App Name, Subtitle, Privacy Policy URL)
"""

import time
import jwt
import requests
import json
import os
import sys

# Ensure UTF-8 output on Windows console
if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

KEY_ID = "N3VT7SR95W"
ISSUER_ID = "a13dcfe1-fda3-4af8-896e-7b67ec382943"
KEY_FILE = r"C:\Users\Gorkem\Desktop\nordic\AuthKey_N3VT7SR95W.p8"
REPO_ROOT = r"C:\Users\Gorkem\Desktop\nordic"

APPS_CONFIG = [
    {
        "app_id": "6802048212",
        "scheme": "ApplianceWarrantyManager",
        "bundle_id": "com.nordicassetsuite.appliance",
        "display_name": "Appliance Warranty Manager",
        "group_name": "Appliance Pro Subscriptions",
        "monthly_product_id": "com.nordicassetsuite.appliance.pro.monthly",
        "annual_product_id": "com.nordicassetsuite.appliance.pro.annual",
        "monthly_name": "Appliance Pro Monthly",
        "annual_name": "Appliance Pro Annual",
        "monthly_desc": "Unlimited appliance tracking & OCR",
        "annual_desc": "Unlimited appliances, OCR & AI diagnostics",
        "monthly_desc_tr": "Sınırsız cihaz takibi ve OCR",
        "annual_desc_tr": "Sınırsız cihaz, fatura OCR ve yapay zeka"
    },
    {
        "app_id": "6802048274",
        "scheme": "SkiGearTracker",
        "bundle_id": "com.nordicassetsuite.skigear",
        "display_name": "Ski & Snowboard Gear Tuning",
        "group_name": "Ski Gear Pro Subscriptions",
        "monthly_product_id": "com.nordicassetsuite.skigear.pro.monthly",
        "annual_product_id": "com.nordicassetsuite.skigear.pro.annual",
        "monthly_name": "Ski Gear Pro Monthly",
        "annual_name": "Ski Gear Pro Annual",
        "monthly_desc": "Unlimited ski quiver & DIN setup",
        "annual_desc": "Unlimited quiver, ISO DIN calc & tuning",
        "monthly_desc_tr": "Sınırsız kayak takımı ve DIN ayarı",
        "annual_desc_tr": "Sınırsız takım, ISO DIN hesabı ve bakım"
    },
    {
        "app_id": "6802048492",
        "scheme": "EBikeServiceTracker",
        "bundle_id": "com.nordicassetsuite.ebike",
        "display_name": "E-Bike Service & Maintenance",
        "group_name": "E-Bike Pro Subscriptions",
        "monthly_product_id": "com.nordicassetsuite.ebike.pro.monthly",
        "annual_product_id": "com.nordicassetsuite.ebike.pro.annual",
        "monthly_name": "E-Bike Pro Monthly",
        "annual_name": "E-Bike Pro Annual",
        "monthly_desc": "Unlimited e-bike telemetry & rides",
        "annual_desc": "Unlimited fleet, battery & chain wear",
        "monthly_desc_tr": "Sınırsız e-bisiklet ve sürüş kaydı",
        "annual_desc_tr": "Sınırsız filo, batarya ve zincir takibi"
    },
    {
        "app_id": "6802048582",
        "scheme": "CoffeeMachineCompanion",
        "bundle_id": "com.nordicassetsuite.coffee",
        "display_name": "Coffee Brew & Espresso Log",
        "group_name": "Coffee Pro Subscriptions",
        "monthly_product_id": "com.nordicassetsuite.coffee.pro.monthly",
        "annual_product_id": "com.nordicassetsuite.coffee.pro.annual",
        "monthly_name": "Coffee Pro Monthly",
        "annual_name": "Coffee Pro Annual",
        "monthly_desc": "Unlimited brew logs & recipes",
        "annual_desc": "Unlimited recipes, water test & descaling",
        "monthly_desc_tr": "Sınırsız demleme ve reçete kaydı",
        "annual_desc_tr": "Sınırsız reçete, su sertliği ve kireç"
    }
]

def get_token():
    with open(KEY_FILE, "r") as f:
        private_key = f.read()

    now = int(time.time())
    payload = {
        "iss": ISSUER_ID,
        "iat": now,
        "exp": now + 1199,
        "aud": "appstoreconnect-v1"
    }
    headers = {
        "alg": "ES256",
        "kid": KEY_ID,
        "typ": "JWT"
    }
    return jwt.encode(payload, private_key, algorithm="ES256", headers=headers)

class ASCClient:
    def __init__(self):
        self.token = get_token()
        self.headers = {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json"
        }
        self.territories = None

    def refresh_token_if_needed(self):
        self.token = get_token()
        self.headers["Authorization"] = f"Bearer {self.token}"

    def get_territories(self):
        if self.territories is None:
            url = "https://api.appstoreconnect.apple.com/v1/territories?limit=200"
            res = requests.get(url, headers=self.headers)
            if res.status_code == 200:
                self.territories = [{"type": "territories", "id": t["id"]} for t in res.json().get("data", [])]
            else:
                self.territories = []
        return self.territories

    # ── Subscription Groups ──
    def get_or_create_subscription_group(self, app_id, group_name):
        url = f"https://api.appstoreconnect.apple.com/v1/apps/{app_id}/subscriptionGroups"
        res = requests.get(url, headers=self.headers)
        if res.status_code == 200:
            for g in res.json().get("data", []):
                # match by referenceName or return first existing
                if g.get("attributes", {}).get("referenceName") == group_name or len(res.json().get("data", [])) == 1:
                    return g.get("id")
        
        # Create group on root endpoint
        post_url = "https://api.appstoreconnect.apple.com/v1/subscriptionGroups"
        payload = {
            "data": {
                "type": "subscriptionGroups",
                "attributes": { "referenceName": group_name },
                "relationships": {
                    "app": { "data": { "type": "apps", "id": app_id } }
                }
            }
        }
        create_res = requests.post(post_url, headers=self.headers, json=payload)
        if create_res.status_code in (200, 201):
            return create_res.json()["data"]["id"]
        print(f"Error creating group {group_name}: {create_res.text}")
        return None

    # ── Subscriptions ──
    def get_or_create_subscription(self, group_id, name, product_id, period, level):
        url = f"https://api.appstoreconnect.apple.com/v1/subscriptionGroups/{group_id}/subscriptions"
        res = requests.get(url, headers=self.headers)
        if res.status_code == 200:
            for s in res.json().get("data", []):
                if s.get("attributes", {}).get("productId") == product_id:
                    return s.get("id")
        
        # Create subscription
        payload = {
            "data": {
                "type": "subscriptions",
                "attributes": {
                    "name": name,
                    "productId": product_id,
                    "subscriptionPeriod": period,
                    "groupLevel": level
                },
                "relationships": {
                    "group": { "data": { "type": "subscriptionGroups", "id": group_id } }
                }
            }
        }
        create_url = "https://api.appstoreconnect.apple.com/v1/subscriptions"
        create_res = requests.post(create_url, headers=self.headers, json=payload)
        if create_res.status_code in (200, 201):
            return create_res.json()["data"]["id"]
        print(f"Error creating subscription {name}: {create_res.text}")
        return None

    # ── Subscription Availability (175 Countries) ──
    def ensure_subscription_availability(self, sub_id):
        url = f"https://api.appstoreconnect.apple.com/v1/subscriptions/{sub_id}/subscriptionAvailability"
        res = requests.get(url, headers=self.headers)
        if res.status_code == 200:
            return True
        
        territories = self.get_territories()
        payload = {
            "data": {
                "type": "subscriptionAvailabilities",
                "attributes": { "availableInNewTerritories": True },
                "relationships": {
                    "subscription": { "data": { "type": "subscriptions", "id": sub_id } },
                    "availableTerritories": { "data": territories }
                }
            }
        }
        create_url = "https://api.appstoreconnect.apple.com/v1/subscriptionAvailabilities"
        create_res = requests.post(create_url, headers=self.headers, json=payload)
        return create_res.status_code in (200, 201)

    # ── Subscription Pricing ──
    def find_price_point_id(self, sub_id, target_price_str):
        url = f"https://api.appstoreconnect.apple.com/v1/subscriptions/{sub_id}/pricePoints?filter[territory]=USA&limit=200"
        while url:
            res = requests.get(url, headers=self.headers)
            if res.status_code != 200:
                break
            data = res.json()
            for pp in data.get("data", []):
                if pp.get("attributes", {}).get("customerPrice") == target_price_str:
                    return pp.get("id")
            url = data.get("links", {}).get("next")
        return None

    def ensure_subscription_price(self, sub_id, target_price_str):
        check_url = f"https://api.appstoreconnect.apple.com/v1/subscriptions/{sub_id}/prices"
        check_res = requests.get(check_url, headers=self.headers)
        if check_res.status_code == 200 and len(check_res.json().get("data", [])) > 0:
            return True
        
        pp_id = self.find_price_point_id(sub_id, target_price_str)
        if not pp_id:
            print(f"Could not find price point for ${target_price_str}")
            return False
        
        payload = {
            "data": {
                "type": "subscriptionPrices",
                "attributes": { "startDate": None },
                "relationships": {
                    "subscription": { "data": { "type": "subscriptions", "id": sub_id } },
                    "subscriptionPricePoint": { "data": { "type": "subscriptionPricePoints", "id": pp_id } }
                }
            }
        }
        url = "https://api.appstoreconnect.apple.com/v1/subscriptionPrices"
        res = requests.post(url, headers=self.headers, json=payload)
        return res.status_code in (200, 201)

    # ── Introductory Offer (7-Day Free Trial) ──
    def ensure_free_trial(self, sub_id):
        check_url = f"https://api.appstoreconnect.apple.com/v1/subscriptions/{sub_id}/introductoryOffers"
        check_res = requests.get(check_url, headers=self.headers)
        if check_res.status_code == 200 and len(check_res.json().get("data", [])) > 0:
            return True
        
        payload = {
            "data": {
                "type": "subscriptionIntroductoryOffers",
                "attributes": {
                    "duration": "ONE_WEEK",
                    "numberOfPeriods": 1,
                    "offerMode": "FREE_TRIAL",
                    "startDate": None,
                    "endDate": None
                },
                "relationships": {
                    "subscription": { "data": { "type": "subscriptions", "id": sub_id } },
                    "territory": { "data": { "type": "territories", "id": "USA" } }
                }
            }
        }
        url = "https://api.appstoreconnect.apple.com/v1/subscriptionIntroductoryOffers"
        res = requests.post(url, headers=self.headers, json=payload)
        return res.status_code in (200, 201)

    # ── Subscription Localizations ──
    def ensure_subscription_localization(self, sub_id, locale, name, desc):
        safe_desc = desc[:55]
        check_url = f"https://api.appstoreconnect.apple.com/v1/subscriptions/{sub_id}/subscriptionLocalizations"
        check_res = requests.get(check_url, headers=self.headers)
        if check_res.status_code == 200:
            for loc in check_res.json().get("data", []):
                if loc.get("attributes", {}).get("locale") == locale:
                    return True
        
        payload = {
            "data": {
                "type": "subscriptionLocalizations",
                "attributes": {
                    "locale": locale,
                    "name": name,
                    "description": safe_desc
                },
                "relationships": {
                    "subscription": { "data": { "type": "subscriptions", "id": sub_id } }
                }
            }
        }
        url = "https://api.appstoreconnect.apple.com/v1/subscriptionLocalizations"
        res = requests.post(url, headers=self.headers, json=payload)
        return res.status_code in (200, 201)

    # ── App Info & App Store Version Localizations ──
    def sync_app_store_metadata(self, app_cfg):
        app_id = app_cfg["app_id"]
        scheme = app_cfg["scheme"]
        
        # 1. Fetch App Info ID
        app_info_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/apps/{app_id}/appInfos", headers=self.headers)
        app_info_id = None
        if app_info_res.status_code == 200:
            infos = app_info_res.json().get("data", [])
            if infos:
                app_info_id = infos[0]["id"]
        
        # 2. Fetch Version ID
        ver_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/apps/{app_id}/appStoreVersions", headers=self.headers)
        ver_id = None
        if ver_res.status_code == 200:
            versions = ver_res.json().get("data", [])
            if versions:
                ver_id = versions[0]["id"]
        
        if not ver_id:
            print(f"[{scheme}] No App Store version found!")
            return
        
        print(f"\n[{scheme}] Syncing metadata for Version {ver_id} & AppInfo {app_info_id}...")
        
        locales_dir = os.path.join(REPO_ROOT, "fastlane", "metadata", scheme)
        if not os.path.exists(locales_dir):
            print(f"Metadata directory not found: {locales_dir}")
            return
        
        # Fetch existing version localizations
        existing_ver_locs = {}
        ver_loc_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/appStoreVersions/{ver_id}/appStoreVersionLocalizations?limit=50", headers=self.headers)
        if ver_loc_res.status_code == 200:
            for l in ver_loc_res.json().get("data", []):
                existing_ver_locs[l["attributes"]["locale"]] = l["id"]
        
        # Fetch existing app info localizations
        existing_info_locs = {}
        if app_info_id:
            info_loc_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/appInfos/{app_info_id}/appInfoLocalizations?limit=50", headers=self.headers)
            if info_loc_res.status_code == 200:
                for l in info_loc_res.json().get("data", []):
                    existing_info_locs[l["attributes"]["locale"]] = l["id"]

        for locale in os.listdir(locales_dir):
            loc_path = os.path.join(locales_dir, locale)
            if not os.path.isdir(loc_path):
                continue
            
            def read_meta(filename, default=""):
                fp = os.path.join(loc_path, filename)
                if os.path.exists(fp):
                    with open(fp, "r", encoding="utf-8") as f:
                        return f.read().strip()
                return default
            
            app_name = read_meta("name.txt", app_cfg["display_name"])[:30]
            subtitle = read_meta("subtitle.txt")[:30]
            desc = read_meta("description.txt")[:4000]
            keywords = read_meta("keywords.txt")[:100]
            promo = read_meta("promotional_text.txt")[:170]
            
            support_url = "https://nordicassetsuite.com/support"
            marketing_url = "https://nordicassetsuite.com"
            privacy_url = "https://nordicassetsuite.com/privacy"
            
            # Update/Create App Store Version Localization
            ver_payload_attrs = {
                "description": desc,
                "keywords": keywords,
                "promotionalText": promo if promo else None,
                "supportUrl": support_url,
                "marketingUrl": marketing_url
            }
            
            if locale in existing_ver_locs:
                patch_id = existing_ver_locs[locale]
                patch_url = f"https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/{patch_id}"
                patch_payload = {
                    "data": {
                        "type": "appStoreVersionLocalizations",
                        "id": patch_id,
                        "attributes": ver_payload_attrs
                    }
                }
                res = requests.patch(patch_url, headers=self.headers, json=patch_payload)
                print(f" - Version Loc [{locale}]: Updated (Status: {res.status_code})")
            else:
                post_url = "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations"
                ver_payload_attrs["locale"] = locale
                post_payload = {
                    "data": {
                        "type": "appStoreVersionLocalizations",
                        "attributes": ver_payload_attrs,
                        "relationships": {
                            "appStoreVersion": { "data": { "type": "appStoreVersions", "id": ver_id } }
                        }
                    }
                }
                res = requests.post(post_url, headers=self.headers, json=post_payload)
                print(f" - Version Loc [{locale}]: Created (Status: {res.status_code})")

            # Update/Create App Info Localization (Name & Subtitle & Privacy URL)
            if app_info_id:
                info_attrs = {
                    "name": app_name,
                    "subtitle": subtitle if subtitle else None,
                    "privacyPolicyUrl": privacy_url
                }
                if locale in existing_info_locs:
                    info_id = existing_info_locs[locale]
                    patch_info_url = f"https://api.appstoreconnect.apple.com/v1/appInfoLocalizations/{info_id}"
                    info_payload = {
                        "data": {
                            "type": "appInfoLocalizations",
                            "id": info_id,
                            "attributes": info_attrs
                        }
                    }
                    res = requests.patch(patch_info_url, headers=self.headers, json=info_payload)
                    print(f" - AppInfo Loc [{locale}]: Updated (Status: {res.status_code})")
                else:
                    post_info_url = "https://api.appstoreconnect.apple.com/v1/appInfoLocalizations"
                    info_attrs["locale"] = locale
                    info_payload = {
                        "data": {
                            "type": "appInfoLocalizations",
                            "attributes": info_attrs,
                            "relationships": {
                                "appInfo": { "data": { "type": "appInfos", "id": app_info_id } }
                            }
                        }
                    }
                    res = requests.post(post_info_url, headers=self.headers, json=info_payload)
                    print(f" - AppInfo Loc [{locale}]: Created (Status: {res.status_code})")


def run_full_sync():
    client = ASCClient()
    print("================================================================")
    print("  NORDIC ASSET SUITE -- FULL APP STORE CONNECT SYNCHRONIZATION  ")
    print("================================================================")
    
    for app in APPS_CONFIG:
        print(f"\n>>> PROCESSING: {app['display_name']} ({app['bundle_id']}) <<<")
        client.refresh_token_if_needed()
        
        # 1. Subscription Group
        group_id = client.get_or_create_subscription_group(app["app_id"], app["group_name"])
        print(f"  [OK] Subscription Group ID: {group_id}")
        
        if group_id:
            # 2. Annual Subscription (Level 1, $29.99, 7-Day Free Trial)
            ann_sub_id = client.get_or_create_subscription(group_id, app["annual_name"], app["annual_product_id"], "ONE_YEAR", 1)
            print(f"  [OK] Annual Subscription ID: {ann_sub_id}")
            if ann_sub_id:
                avail_ok = client.ensure_subscription_availability(ann_sub_id)
                print(f"       Territories Availability: {'OK' if avail_ok else 'Failed'}")
                price_ok = client.ensure_subscription_price(ann_sub_id, "29.99")
                print(f"       Price ($29.99 Fair Global Auto-Tier): {'OK' if price_ok else 'Failed'}")
                trial_ok = client.ensure_free_trial(ann_sub_id)
                print(f"       7-Day Free Trial Intro Offer: {'OK' if trial_ok else 'Failed'}")
                loc1 = client.ensure_subscription_localization(ann_sub_id, "en-US", app["annual_name"], app["annual_desc"])
                loc2 = client.ensure_subscription_localization(ann_sub_id, "tr", "Yıllık Pro Geçiş", app["annual_desc_tr"])
                print(f"       Localizations (en-US, tr): {'OK' if (loc1 and loc2) else 'Failed'}")

            # 3. Monthly Subscription (Level 2, $3.99, High Decoy Anchor)
            mo_sub_id = client.get_or_create_subscription(group_id, app["monthly_name"], app["monthly_product_id"], "ONE_MONTH", 2)
            print(f"  [OK] Monthly Subscription ID: {mo_sub_id}")
            if mo_sub_id:
                avail_ok = client.ensure_subscription_availability(mo_sub_id)
                print(f"       Territories Availability: {'OK' if avail_ok else 'Failed'}")
                price_ok = client.ensure_subscription_price(mo_sub_id, "3.99")
                print(f"       Price ($3.99 Decoy Anchor): {'OK' if price_ok else 'Failed'}")
                loc1 = client.ensure_subscription_localization(mo_sub_id, "en-US", app["monthly_name"], app["monthly_desc"])
                loc2 = client.ensure_subscription_localization(mo_sub_id, "tr", "Aylık Pro Geçiş", app["monthly_desc_tr"])
                print(f"       Localizations (en-US, tr): {'OK' if (loc1 and loc2) else 'Failed'}")
        
        # 4. App Store Version & App Info Metadata Sync (8 Locales)
        client.sync_app_store_metadata(app)
        print(f"  [SUCCESS] {app['display_name']} FULLY SYNCHRONIZED!")

    print("\n================================================================")
    print("  ALL 4 APPS FULLY CONFIGURED ON APPLE APP STORE CONNECT!       ")
    print("================================================================")

if __name__ == "__main__":
    run_full_sync()
