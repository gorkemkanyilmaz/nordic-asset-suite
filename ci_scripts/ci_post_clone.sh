#!/usr/bin/env bash
#
# Xcode Cloud Post-Clone Script (ci_post_clone.sh)
# Nordic Asset Suite — Automated CI/CD Pipeline
# Triggered automatically upon git push to main for TestFlight deployment.
#

set -e

echo "=========================================================="
echo "    Nordic Asset Suite — Xcode Cloud Post-Clone CI/CD"
echo "=========================================================="

SCRIPT_DIR="$(dirname "$0")"
REPO_ROOT="$SCRIPT_DIR/.."

echo "-> 1. Auditing Swift 6 Strict Concurrency (-strict-concurrency=complete)..."
bash "$REPO_ROOT/BuildScripts/verify_concurrency.sh"

echo ""
echo "-> 2. Executing Full XCTest Suite across all AssetCore Modules..."
bash "$REPO_ROOT/BuildScripts/run_all_tests.sh"

echo ""
echo "-> 3. Running Pre-Submission Security & Privacy Audit..."
bash "$REPO_ROOT/BuildScripts/package_release.sh"

echo ""
echo "=========================================================="
echo "    XCODE CLOUD CI CHECKS PASSED — READY FOR ARCHIVE"
echo "=========================================================="
