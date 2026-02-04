#!/bin/bash
# PlasmaCodexBar - Launcher Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec /usr/bin/python3 "$SCRIPT_DIR/plasmacodexbar_monitor.py" "$@"
