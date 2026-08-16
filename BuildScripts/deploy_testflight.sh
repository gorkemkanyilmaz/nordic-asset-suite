#!/usr/bin/env bash
#
# Nordic Asset Suite — Bulletproof CI/CD TestFlight Deployer
# Uses native xcodebuild API Key authentication for fully automated
# certificate creation, provisioning profile management, and TestFlight upload.
# No Fastlane dependency. No manual signing setup required.
#
set -euo pipefail

# ─── Required Environment Variables ───
: "${APP_STORE_CONNECT_KEY_ID:?APP_STORE_CONNECT_KEY_ID is not set}"
: "${APP_STORE_CONNECT_ISSUER_ID:?APP_STORE_CONNECT_ISSUER_ID is not set}"
: "${APP_STORE_CONNECT_PRIVATE_KEY:?APP_STORE_CONNECT_PRIVATE_KEY is not set}"
: "${APPLE_TEAM_ID:?APPLE_TEAM_ID is not set}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# ─── 1. Install App Store Connect API Key ───
echo "=========================================================="
echo "  Step 1: Installing App Store Connect API Key"
echo "=========================================================="
AUTH_KEY_DIR="$HOME/private_keys"
AUTH_KEY_PATH="$AUTH_KEY_DIR/AuthKey_${APP_STORE_CONNECT_KEY_ID}.p8"
mkdir -p "$AUTH_KEY_DIR"
echo "$APP_STORE_CONNECT_PRIVATE_KEY" > "$AUTH_KEY_PATH"
chmod 600 "$AUTH_KEY_PATH"
echo "   [OK] API Key installed at $AUTH_KEY_PATH"

# ─── Common xcodebuild auth flags ───
AUTH_FLAGS=(
    -allowProvisioningUpdates
    -authenticationKeyPath "$AUTH_KEY_PATH"
    -authenticationKeyID "$APP_STORE_CONNECT_KEY_ID"
    -authenticationKeyIssuerID "$APP_STORE_CONNECT_ISSUER_ID"
)

# ─── 2. Define all 4 applications ───
declare -a APP_NAMES=("ApplianceWarrantyManager" "SkiGearTracker" "EBikeServiceTracker" "CoffeeMachineCompanion")
declare -a BUNDLE_IDS=("com.nordicassetsuite.appliance" "com.nordicassetsuite.skigear" "com.nordicassetsuite.ebike" "com.nordicassetsuite.coffee")

BUILD_DIR="$REPO_ROOT/build"
mkdir -p "$BUILD_DIR/archives" "$BUILD_DIR/ipa"

FAILED=0

for i in "${!APP_NAMES[@]}"; do
    APP="${APP_NAMES[$i]}"
    BUNDLE_ID="${BUNDLE_IDS[$i]}"
    ARCHIVE_PATH="$BUILD_DIR/archives/$APP.xcarchive"
    EXPORT_DIR="$BUILD_DIR/ipa/$APP"
    EXPORT_OPTIONS="$BUILD_DIR/${APP}_ExportOptions.plist"

    echo ""
    echo "=========================================================="
    echo "  Step 2.$((i+1)): Archiving $APP ($BUNDLE_ID)"
    echo "=========================================================="

    # ─── Archive with automatic signing via API Key ───
    xcodebuild archive \
        -project NordicAssetSuite.xcodeproj \
        -scheme "$APP" \
        -destination "generic/platform=iOS" \
        -archivePath "$ARCHIVE_PATH" \
        DEVELOPMENT_TEAM="$APPLE_TEAM_ID" \
        CODE_SIGN_STYLE=Automatic \
        "${AUTH_FLAGS[@]}" \
        -quiet || { echo "❌ Archive FAILED for $APP"; FAILED=1; continue; }

    echo "   [OK] Archive succeeded for $APP"

    # ─── Generate ExportOptions.plist for App Store Connect upload ───
    cat > "$EXPORT_OPTIONS" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store-connect</string>
    <key>destination</key>
    <string>upload</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>teamID</key>
    <string>${APPLE_TEAM_ID}</string>
    <key>manageAppVersionAndBuildNumber</key>
    <true/>
</dict>
</plist>
PLIST

    echo ""
    echo "=========================================================="
    echo "  Step 3.$((i+1)): Exporting & Uploading $APP to TestFlight"
    echo "=========================================================="

    # ─── Export + Upload in one step via destination=upload ───
    xcodebuild -exportArchive \
        -archivePath "$ARCHIVE_PATH" \
        -exportOptionsPlist "$EXPORT_OPTIONS" \
        -exportPath "$EXPORT_DIR" \
        "${AUTH_FLAGS[@]}" \
        -quiet || { echo "❌ Export/Upload FAILED for $APP"; FAILED=1; continue; }

    echo "   ✅ $APP successfully uploaded to TestFlight!"
done

# ─── Cleanup sensitive key material ───
rm -f "$AUTH_KEY_PATH"

echo ""
echo "=========================================================="
if [ "$FAILED" -eq 0 ]; then
    echo "  🎉 ALL 4 APPS UPLOADED TO APPLE TESTFLIGHT SUCCESSFULLY"
else
    echo "  ⚠️  Some apps failed. Check the logs above."
    exit 1
fi
echo "=========================================================="
