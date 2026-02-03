#!/bin/bash

# AI Usage Monitor - Uninstallation Script

set -e

APP_NAME="ai-usage-monitor"
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
AUTOSTART_FILE="$HOME/.config/autostart/$APP_NAME.desktop"

echo "==================================="
echo "  AI Usage Monitor - Uninstall"
echo "==================================="
echo

# Kill running instance
pkill -f "ai_usage_monitor.py" 2>/dev/null || true

echo "[1/3] Removing application files..."
rm -rf "$INSTALL_DIR"

echo "[2/3] Removing desktop entry..."
rm -f "$DESKTOP_FILE"

echo "[3/3] Removing autostart entry..."
rm -f "$AUTOSTART_FILE"

echo
echo "Uninstallation complete!"
echo "Configuration files in ~/.config/ai-usage-monitor/ were preserved."
echo "Remove them manually if needed."
