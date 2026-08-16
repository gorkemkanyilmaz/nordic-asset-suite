#!/usr/bin/env bash
#
# Nordic Asset Suite — TestFlight Archive & Upload Automation Script
# Archives all 4 apps and uploads IPAs to App Store Connect via xcrun altool.
#

set -e

SCRIPT_DIR="$(dirname "$0")"
REPO_ROOT="$SCRIPT_DIR/.."
cd "$REPO_ROOT"

KEY_ID="${APP_STORE_CONNECT_KEY_ID:-$1}"
ISSUER_ID="${APP_STORE_CONNECT_ISSUER_ID:-$2}"

echo "=========================================================="
echo "    Nordic Asset Suite — TestFlight Uploader"
echo "=========================================================="

# 1. Generate Native Xcode Project linking AssetCore
echo "-> Generating Xcode Projects with XcodeGen..."
xcodegen generate

mkdir -p build/archives
mkdir -p build/ipa

APPS=("ApplianceWarrantyManager" "SkiGearTracker" "EBikeServiceTracker" "CoffeeMachineCompanion")

for APP in "${APPS[@]}"; do
    echo ""
    echo "=========================================================="
    echo "-> Building & Archiving: $APP"
    echo "=========================================================="
    
    ARCHIVE_PATH="build/archives/$APP.xcarchive"
    IPA_DIR="build/ipa/$APP"
    mkdir -p "$IPA_DIR"
    
    xcodebuild archive \
        -project NordicAssetSuite.xcodeproj \
        -scheme "$APP" \
        -destination "generic/platform=iOS" \
        -archivePath "$ARCHIVE_PATH" \
        CODE_SIGNING_ALLOWED=NO \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGN_IDENTITY="" \
        AD_HOC_CODE_SIGNING_ALLOWED=YES
    
    echo "-> Creating IPA package for $APP..."
    APP_BUNDLE_PATH="$ARCHIVE_PATH/Products/Applications/$APP.app"
    
    # Create Payload folder for standard IPA packaging
    mkdir -p "$IPA_DIR/Payload"
    cp -R "$APP_BUNDLE_PATH" "$IPA_DIR/Payload/"
    
    IPA_PATH="build/ipa/$APP.ipa"
    (cd "$IPA_DIR" && zip -r -q "../../ipa/$APP.ipa" Payload)
    
    echo "   [CREATED] $IPA_PATH"
    
    # Upload to TestFlight if API Key is available
    if [ -f ~/.appstoreconnect/private_keys/AuthKey_${KEY_ID}.p8 ] && [ -n "$ISSUER_ID" ]; then
        echo "-> Uploading $APP.ipa to Apple TestFlight..."
        xcrun altool --upload-app \
            -f "$IPA_PATH" \
            -t ios \
            --apiKey "$KEY_ID" \
            --apiIssuer "$ISSUER_ID" || echo "Note: If provisioning profile is required, check App Store Connect profile settings."
    else
        echo "-> API Key not detected in environment. Skipping upload."
    fi
done

echo ""
echo "=========================================================="
echo "    ALL 4 APPLICATIONS ARCHIVED & PROCESSED"
echo "=========================================================="
