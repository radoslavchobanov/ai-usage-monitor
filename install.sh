#!/bin/bash

# PlasmaCodexBar - Installation Script for Linux
# Tested on Manjaro/Arch Linux

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="plasmacodexbar"
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
ICON_DIR="$HOME/.local/share/icons/hicolor"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
AUTOSTART_FILE="$HOME/.config/autostart/$APP_NAME.desktop"

echo "==================================="
echo "  PlasmaCodexBar - Installation"
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

echo "[1/5] Creating installation directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/icons"
mkdir -p "$(dirname "$DESKTOP_FILE")"
mkdir -p "$(dirname "$AUTOSTART_FILE")"

echo "[2/5] Installing application..."
cp "$SCRIPT_DIR/plasmacodexbar_monitor.py" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/plasmacodexbar_monitor.py"

echo "[3/5] Installing icons..."
# Copy SVG icons
cp -r "$SCRIPT_DIR/icons/"* "$INSTALL_DIR/icons/" 2>/dev/null || true

# Install to system icon directories for desktop integration
mkdir -p "$ICON_DIR/scalable/apps"
cp "$SCRIPT_DIR/icons/app-icon.svg" "$ICON_DIR/scalable/apps/$APP_NAME.svg" 2>/dev/null || true

# Generate PNG icons at various sizes for better compatibility
for size in 16 22 24 32 48 64 128 256; do
    mkdir -p "$ICON_DIR/${size}x${size}/apps"
    if command -v rsvg-convert &> /dev/null; then
        rsvg-convert -w $size -h $size "$SCRIPT_DIR/icons/app-icon.svg" -o "$ICON_DIR/${size}x${size}/apps/$APP_NAME.png" 2>/dev/null || true
    elif command -v inkscape &> /dev/null; then
        inkscape -w $size -h $size "$SCRIPT_DIR/icons/app-icon.svg" -o "$ICON_DIR/${size}x${size}/apps/$APP_NAME.png" 2>/dev/null || true
    fi
done

# Update icon cache if possible
gtk-update-icon-cache "$ICON_DIR" 2>/dev/null || true

echo "[4/5] Creating desktop entry..."
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=PlasmaCodexBar
Comment=Monitor AI usage limits and costs
Exec=/usr/bin/python3 $INSTALL_DIR/plasmacodexbar_monitor.py
Icon=$APP_NAME
Terminal=false
Type=Application
Categories=Utility;Monitor;
StartupNotify=false
EOF

echo "[5/5] Setting up autostart..."
cat > "$AUTOSTART_FILE" << EOF
[Desktop Entry]
Name=PlasmaCodexBar
Comment=Monitor AI usage limits and costs
Exec=/usr/bin/python3 $INSTALL_DIR/plasmacodexbar_monitor.py
Icon=$APP_NAME
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
echo "Icons installed to: $ICON_DIR"
echo
echo "To start the application:"
echo "  python3 $INSTALL_DIR/plasmacodexbar_monitor.py"
echo
echo "Or search for 'PlasmaCodexBar' in your application menu."
echo
echo "To uninstall, run: $SCRIPT_DIR/uninstall.sh"
