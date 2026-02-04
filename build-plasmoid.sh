#!/bin/bash

# Build script for KDE Store .plasmoid package

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="1.0.0"
PACKAGE_NAME="plasmacodexbar-${VERSION}.plasmoid"

echo "Building PlasmaCodexBar plasmoid package..."

cd "$SCRIPT_DIR"

# Ensure backend is in plasmoid
cp plasmacodexbar-backend plasmoid/contents/code/backend.py
chmod +x plasmoid/contents/code/backend.py

# Create the .plasmoid file (it's just a zip)
cd plasmoid
rm -f "$SCRIPT_DIR/$PACKAGE_NAME"
zip -r "$SCRIPT_DIR/$PACKAGE_NAME" .

echo ""
echo "=========================================="
echo "  Package created: $PACKAGE_NAME"
echo "=========================================="
echo ""
echo "To install locally for testing:"
echo "  kpackagetool6 -t Plasma/Applet -i $PACKAGE_NAME"
echo ""
echo "To upload to KDE Store (store.kde.org):"
echo "  1. Go to https://store.kde.org"
echo "  2. Log in with your KDE Identity account"
echo "  3. Click your profile -> 'Add Product'"
echo "  4. Select category: Plasma 6 -> Plasma Widgets"
echo "  5. Upload: $PACKAGE_NAME"
echo "  6. Add description, screenshots, changelog"
echo ""
echo "Users can then install via:"
echo "  Right-click desktop -> 'Add Widgets' -> 'Get New Widgets' -> Search"
