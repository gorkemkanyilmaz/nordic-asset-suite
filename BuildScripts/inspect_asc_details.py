#!/usr/bin/env python3
import time
import jwt
import requests
import json

KEY_ID = "N3VT7SR95W"
ISSUER_ID = "a13dcfe1-fda3-4af8-896e-7b67ec382943"
KEY_FILE = r"C:\Users\Gorkem\Desktop\nordic\AuthKey_N3VT7SR95W.p8"

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

def inspect_apps():
    token = get_token()
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    app_ids = {
        "Appliance Warranty Manager": "6802048212",
        "Ski Gear Tracker": "6802048274",
        "EBike Service Tracker": "6802048492",
        "Coffee Machine Companion": "6802048582"
    }
    
    for name, app_id in app_ids.items():
        print(f"\n=======================================================")
        print(f"Checking App: {name} (ID: {app_id})")
        print(f"=======================================================")
        
        # 1. Subscription Groups
        sg_url = f"https://api.appstoreconnect.apple.com/v1/apps/{app_id}/subscriptionGroups"
        res = requests.get(sg_url, headers=headers)
        if res.status_code == 200:
            groups = res.json().get("data", [])
            print(f"Subscription Groups ({len(groups)}):")
            for g in groups:
                print(f" - Group ID: {g.get('id')} | Reference: {g.get('attributes', {}).get('referenceName')}")
                # check subscriptions in this group
                sub_url = f"https://api.appstoreconnect.apple.com/v1/subscriptionGroups/{g.get('id')}/subscriptions"
                sub_res = requests.get(sub_url, headers=headers)
                if sub_res.status_code == 200:
                    subs = sub_res.json().get("data", [])
                    print(f"   Subscriptions ({len(subs)}):")
                    for s in subs:
                        attrs = s.get("attributes", {})
                        print(f"    * Sub ID: {s.get('id')} | ProductID: {attrs.get('productId')} | Name: {attrs.get('name')} | State: {attrs.get('state')} | Period: {attrs.get('subscriptionPeriod')}")
        else:
            print(f"Failed to fetch subscription groups: {res.status_code} - {res.text[:200]}")
            
        # 2. App Store Versions
        v_url = f"https://api.appstoreconnect.apple.com/v1/apps/{app_id}/appStoreVersions"
        res = requests.get(v_url, headers=headers)
        if res.status_code == 200:
            versions = res.json().get("data", [])
            print(f"App Store Versions ({len(versions)}):")
            for v in versions:
                v_attrs = v.get("attributes", {})
                print(f" - Version ID: {v.get('id')} | String: {v_attrs.get('versionString')} | State: {v_attrs.get('appStoreState')}")
                
                # Check localizations for this version
                loc_url = f"https://api.appstoreconnect.apple.com/v1/appStoreVersions/{v.get('id')}/appStoreVersionLocalizations"
                loc_res = requests.get(loc_url, headers=headers)
                if loc_res.status_code == 200:
                    locs = loc_res.json().get("data", [])
                    print(f"   Localizations ({len(locs)}): {[l.get('attributes', {}).get('locale') for l in locs]}")
        else:
            print(f"Failed to fetch versions: {res.status_code} - {res.text[:200]}")

if __name__ == "__main__":
    inspect_apps()
