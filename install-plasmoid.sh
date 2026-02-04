#!/bin/bash

# PlasmaCodexBar - Quick Install Script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLASMOID_DIR="$SCRIPT_DIR/plasmoid"

echo "========================================"
echo "  PlasmaCodexBar - Quick Install"
echo "========================================"
echo

# Check for KDE Plasma 6
if ! command -v plasmashell &> /dev/null; then
    echo "Error: KDE Plasma is not installed."
    exit 1
fi

if ! command -v kpackagetool6 &> /dev/null; then
    echo "Error: kpackagetool6 not found. This widget requires Plasma 6."
    exit 1
fi

echo "[1/3] Removing old version (if exists)..."
kpackagetool6 -t Plasma/Applet -r org.kde.plasma.plasmacodexbar 2>/dev/null || true

echo "[2/3] Installing plasmoid..."
kpackagetool6 -t Plasma/Applet -i "$PLASMOID_DIR"

echo "[3/3] Done!"
echo
echo "========================================="
echo "  Installation complete!"
echo "========================================="
echo
echo "The widget should now appear in your system tray."
echo
echo "If not visible, add it manually:"
echo "  1. Right-click on the system tray"
echo "  2. Select 'Configure System Tray...'"
echo "  3. Go to 'Entries' tab"
echo "  4. Find 'PlasmaCodexBar' and set to 'Always shown'"
echo
echo "To uninstall:"
echo "  kpackagetool6 -t Plasma/Applet -r org.kde.plasma.plasmacodexbar"
