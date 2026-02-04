#!/bin/bash

# AI Usage Monitor - KDE Plasma Applet Installation Script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLASMOID_DIR="$SCRIPT_DIR/plasmoid"
BACKEND_SCRIPT="$SCRIPT_DIR/ai-usage-backend"

echo "========================================"
echo "  AI Usage Monitor - Plasmoid Install"
echo "========================================"
echo

# Check for KDE Plasma
if ! command -v plasmashell &> /dev/null; then
    echo "Error: KDE Plasma is not installed."
    exit 1
fi

# Check for kpackagetool
KPACKAGETOOL=""
if command -v kpackagetool6 &> /dev/null; then
    KPACKAGETOOL="kpackagetool6"
elif command -v kpackagetool5 &> /dev/null; then
    KPACKAGETOOL="kpackagetool5"
else
    echo "Error: kpackagetool not found. Install plasma-sdk."
    exit 1
fi

echo "[1/4] Installing backend service..."
mkdir -p "$HOME/.local/bin"
cp "$BACKEND_SCRIPT" "$HOME/.local/bin/ai-usage-backend"
chmod +x "$HOME/.local/bin/ai-usage-backend"

# Add to PATH if needed
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Note: Add ~/.local/bin to your PATH for the backend to work."
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo "[2/4] Removing old plasmoid (if exists)..."
$KPACKAGETOOL -t Plasma/Applet -r org.kde.plasma.aiusagemonitor 2>/dev/null || true

echo "[3/4] Installing plasmoid..."
$KPACKAGETOOL -t Plasma/Applet -i "$PLASMOID_DIR"

echo "[4/4] Done!"
echo
echo "Installation complete!"
echo
echo "To add the applet to your system tray:"
echo "  1. Right-click on the system tray"
echo "  2. Select 'Configure System Tray...'"
echo "  3. Go to 'Entries' tab"
echo "  4. Find 'AI Usage Monitor' and set to 'Always shown'"
echo
echo "Or restart plasmashell:"
echo "  kquitapp5 plasmashell && kstart5 plasmashell"
echo
echo "To uninstall:"
echo "  $KPACKAGETOOL -t Plasma/Applet -r org.kde.plasma.aiusagemonitor"
