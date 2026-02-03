#!/bin/bash

# AI Usage Monitor - Installation Script for Linux
# Tested on Manjaro/Arch Linux

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="ai-usage-monitor"
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
AUTOSTART_FILE="$HOME/.config/autostart/$APP_NAME.desktop"

echo "==================================="
echo "  AI Usage Monitor - Installation"
echo "==================================="
echo

# Check for Python
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not installed."
    exit 1
fi

# Check for GTK3
if ! /usr/bin/python3 -c "import gi; gi.require_version('Gtk', '3.0'); from gi.repository import Gtk" 2>/dev/null; then
    echo "Error: GTK3 Python bindings are required."
    echo "Install with: sudo pacman -S python-gobject gtk3"
    exit 1
fi

echo "[1/4] Creating installation directory..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$(dirname "$DESKTOP_FILE")"
mkdir -p "$(dirname "$AUTOSTART_FILE")"

echo "[2/4] Installing application..."
cp "$SCRIPT_DIR/ai_usage_monitor.py" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/ai_usage_monitor.py"

echo "[3/4] Creating desktop entry..."
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=AI Usage Monitor
Comment=Monitor AI usage limits and costs
Exec=/usr/bin/python3 $INSTALL_DIR/ai_usage_monitor.py
Icon=utilities-system-monitor
Terminal=false
Type=Application
Categories=Utility;Monitor;
StartupNotify=false
EOF

echo "[4/4] Setting up autostart..."
cat > "$AUTOSTART_FILE" << EOF
[Desktop Entry]
Name=AI Usage Monitor
Comment=Monitor AI usage limits and costs
Exec=/usr/bin/python3 $INSTALL_DIR/ai_usage_monitor.py
Icon=utilities-system-monitor
Terminal=false
Type=Application
Categories=Utility;Monitor;
StartupNotify=false
X-GNOME-Autostart-enabled=true
X-KDE-autostart-phase=2
EOF

echo
echo "Installation complete!"
echo
echo "The application has been installed to: $INSTALL_DIR"
echo "Desktop entry created at: $DESKTOP_FILE"
echo "Autostart entry created at: $AUTOSTART_FILE"
echo
echo "To start the application:"
echo "  python3 $INSTALL_DIR/ai_usage_monitor.py"
echo
echo "Or search for 'AI Usage Monitor' in your application menu."
echo
echo "To uninstall, run: $SCRIPT_DIR/uninstall.sh"
