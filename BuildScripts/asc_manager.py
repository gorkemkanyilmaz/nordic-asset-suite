#!/usr/bin/env python3
import time
import jwt
import requests
import json
import os

KEY_ID = "N3VT7SR95W"
ISSUER_ID = "a13dcfe1-fda3-4af8-896e-7b67ec382943"
KEY_FILE = r"C:\Users\Gorkem\Desktop\nordic\AuthKey_N3VT7SR95W.p8"
TEAM_ID = "H2TTF8894Z"

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
    token = jwt.encode(payload, private_key, algorithm="ES256", headers=headers)
    return token

def test_connection():
    token = get_token()
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    print("[1] Testing connection to App Store Connect API...")
    url = "https://api.appstoreconnect.apple.com/v1/apps"
    res = requests.get(url, headers=headers)
    print(f"Status Code: {res.status_code}")
    if res.status_code == 200:
        data = res.json()
        apps = data.get("data", [])
        print(f"[OK] Connection Successful! Found {len(apps)} apps in this account:")
        for app in apps:
            attrs = app.get("attributes", {})
            print(f" - ID: {app.get('id')} | Name: {attrs.get('name')} | BundleID: {attrs.get('bundleId')}")
        return apps
    else:
        print(f"[ERROR] Response: {res.text}")
        return None

if __name__ == "__main__":
    test_connection()
