#!/bin/bash
# AI Usage Monitor - Launcher Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec /usr/bin/python3 "$SCRIPT_DIR/ai_usage_monitor.py" "$@"
