#!/bin/bash

# AI Usage Monitor - Uninstallation Script

set -e

APP_NAME="ai-usage-monitor"
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
ICON_DIR="$HOME/.local/share/icons/hicolor"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
AUTOSTART_FILE="$HOME/.config/autostart/$APP_NAME.desktop"
TMP_ICONS="/tmp/ai-usage-monitor-icons"

echo "==================================="
echo "  AI Usage Monitor - Uninstall"
echo "==================================="
echo

# Kill running instance
pkill -f "ai_usage_monitor.py" 2>/dev/null || true

echo "[1/4] Removing application files..."
rm -rf "$INSTALL_DIR"

echo "[2/4] Removing icons..."
rm -f "$ICON_DIR/scalable/apps/$APP_NAME.svg"
for size in 16 22 24 32 48 64 128 256; do
    rm -f "$ICON_DIR/${size}x${size}/apps/$APP_NAME.png"
done
rm -rf "$TMP_ICONS"

# Update icon cache
gtk-update-icon-cache "$ICON_DIR" 2>/dev/null || true

echo "[3/4] Removing desktop entry..."
rm -f "$DESKTOP_FILE"

echo "[4/4] Removing autostart entry..."
rm -f "$AUTOSTART_FILE"

echo
echo "Uninstallation complete!"
echo "Configuration files in ~/.config/ai-usage-monitor/ were preserved."
echo "Remove them manually if needed."
