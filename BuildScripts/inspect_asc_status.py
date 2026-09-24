import time
import jwt
import requests
import json

KEY_ID = "N3VT7SR95W"
ISSUER_ID = "a13dcfe1-fda3-4af8-896e-7b67ec382943"
KEY_FILE = r"C:\Users\Gorkem\Desktop\nordic\AuthKey_N3VT7SR95W.p8"

with open(KEY_FILE, "r") as f:
    private_key = f.read()

now = int(time.time())
payload = {
    "iss": ISSUER_ID,
    "iat": now,
    "exp": now + 600,
    "aud": "appstoreconnect-v1"
}
headers = {
    "alg": "ES256",
    "kid": KEY_ID,
    "typ": "JWT"
}
token = jwt.encode(payload, private_key, algorithm="ES256", headers=headers)
auth_headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}

apps = [
    ("6802048212", "Appliance Warranty Manager"),
    ("6802048274", "Ski Gear Tracker"),
    ("6802048492", "EBike Service Tracker"),
    ("6802048582", "Coffee Machine Companion")
]

for app_id, app_name in apps:
    print(f"\n=================== {app_name} ({app_id}) ===================")
    # Check subscription groups
    res = requests.get(f"https://api.appstoreconnect.apple.com/v1/apps/{app_id}/subscriptionGroups", headers=auth_headers)
    if res.status_code == 200:
        groups = res.json().get("data", [])
        print(f"Subscription Groups: {len(groups)}")
        for g in groups:
            gid = g["id"]
            gname = g.get("attributes", {}).get("referenceName")
            print(f"  - Group: {gname} (ID: {gid})")
            
            # Check subscriptions in group
            sub_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/subscriptionGroups/{gid}/subscriptions", headers=auth_headers)
            if sub_res.status_code == 200:
                subs = sub_res.json().get("data", [])
                print(f"    Subscriptions ({len(subs)}):")
                for s in subs:
                    sid = s["id"]
                    sname = s.get("attributes", {}).get("name")
                    pid = s.get("attributes", {}).get("productId")
                    period = s.get("attributes", {}).get("subscriptionPeriod")
                    print(f"      * {sname} ({pid}) - {period} [ID: {sid}]")
                    
                    # Check intro offer
                    intro_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/subscriptions/{sid}/introductoryOffers", headers=auth_headers)
                    if intro_res.status_code == 200:
                        intros = intro_res.json().get("data", [])
                        print(f"        Intro Offers ({len(intros)}): {[i.get('attributes', {}).get('offerMode') for i in intros]}")
                    
                    # Check localizations
                    loc_res = requests.get(f"https://api.appstoreconnect.apple.com/v1/subscriptions/{sid}/subscriptionLocalizations", headers=auth_headers)
                    if loc_res.status_code == 200:
                        locs = loc_res.json().get("data", [])
                        loc_keys = [l.get("attributes", {}).get("locale") for l in locs]
                        print(f"        Localizations ({len(locs)}): {loc_keys}")
    else:
        print(f"Failed to fetch groups: {res.status_code} {res.text}")
