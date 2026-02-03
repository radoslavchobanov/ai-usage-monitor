# AI Usage Monitor

<p align="center">
  <img src="https://img.shields.io/badge/version-3.1.0-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/platform-Linux-green.svg" alt="Platform">
  <img src="https://img.shields.io/badge/python-3.8+-yellow.svg" alt="Python">
  <img src="https://img.shields.io/badge/license-MIT-orange.svg" alt="License">
</p>

A Linux system tray application for monitoring AI subscription usage limits and costs. Inspired by [CodexBar](https://github.com/steipete/CodexBar) for macOS.

## Features

- **Real Subscription Data**: Fetches actual usage from Claude and OpenAI OAuth APIs
- **Multi-Provider Support**: Monitor Claude (Anthropic) and Codex/ChatGPT (OpenAI)
- **Dark & Light Themes**: Professional UI with theme switching via Settings
- **Usage Tracking**:
  - Session usage (5-hour window)
  - Weekly usage with reset countdown
  - Model-specific quotas (Sonnet, Opus, etc.)
  - Extra usage/overage tracking
- **Visual Indicators**: Color-coded progress bars (green → yellow → red)
- **System Tray Integration**: Quick access from your panel
- **CLI Mode**: Check status from terminal with `--status` flag

## Screenshots

*Click the system tray icon to open the usage panel*

The app displays:
- Provider tabs (Claude, Codex)
- Plan information and last update time
- Session and weekly usage with progress bars
- Reset countdown timers
- Cost tracking (local estimates)

## Installation

### Prerequisites

```bash
# Ubuntu/Debian
sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-ayatanaappindicator3-0.1

# Arch/Manjaro
sudo pacman -S python-gobject gtk3 libayatana-appindicator

# Fedora
sudo dnf install python3-gobject gtk3 libayatana-appindicator-gtk3
```

### Install

```bash
git clone https://github.com/anthropics/ai-usage-monitor.git
cd ai-usage-monitor
./install.sh
```

This will:
- Copy files to `~/.local/share/ai-usage-monitor/`
- Create desktop entry for autostart
- Add application to your system menu

## Usage

### GUI Mode (System Tray)

```bash
# Run directly
./run.sh

# Or via Python
python3 ai_usage_monitor.py
```

### CLI Mode

```bash
python3 ai_usage_monitor.py --status
```

Output:
```
╭────────────────────────────────────────────────────╮
│      AI Usage Monitor v3.1 - Theme Support         │
╰────────────────────────────────────────────────────╯

◐ Claude (Max Plan)
  Session   ████████░░░░░░░░░░░░░  42%  (resets in 2h 15m)
  Weekly    ██████░░░░░░░░░░░░░░░  31%  (resets in 4d 12h)
  Sonnet    █████░░░░░░░░░░░░░░░░  28%
```

## Data Sources

### Claude (Anthropic OAuth API)

The app authenticates using your Claude Code CLI credentials stored in `~/.claude/`. It fetches real subscription usage from Anthropic's OAuth API.

**Tracked metrics:**
- Session usage (5-hour rolling window)
- Weekly usage (7-day rolling window)
- Model-specific quotas (Sonnet, Opus, Haiku)
- Extra usage spending (if enabled)
- Plan information

### Codex/ChatGPT (OpenAI OAuth API)

Uses the same OAuth endpoint as CodexBar to fetch ChatGPT Plus/Pro usage data from `~/.codex/` credentials.

## Configuration

### Settings Dialog

Click the **⚙ Settings** button in the app to:
- Switch between Dark and Light themes

Settings are stored in: `~/.config/ai-usage-monitor/settings.json`

### App Config

Main configuration: `~/.config/ai-usage-monitor/config.json`

```json
{
  "refresh_interval": 60,
  "enabled_providers": ["claude", "codex"],
  "show_notifications": true
}
```

## Theme Support

The app includes two professionally designed themes:

- **Dark Theme** (default): Easy on the eyes, perfect for dark desktop environments
- **Light Theme**: Clean and bright for light desktop setups

Both themes feature proper contrast ratios for accessibility.

## Architecture

```
~/.claude/                        # Claude Code credentials
├── credentials.json             # OAuth tokens (auto-managed)
└── ...

~/.codex/                        # Codex CLI credentials
├── auth.json                    # OAuth tokens
└── ...

~/.config/ai-usage-monitor/      # App configuration
├── config.json                  # General settings
└── settings.json                # Theme preferences

/tmp/ai-usage-monitor-icons/     # Generated tray icons (temporary)
```

## Uninstall

```bash
./uninstall.sh
```

## Troubleshooting

### "Not connected" for Claude

1. Make sure Claude Code CLI is installed and authenticated:
   ```bash
   claude --version
   ```
2. If not authenticated, run `claude` and complete the login flow

### "Not connected" for Codex

1. Install and authenticate with Codex CLI
2. Check that `~/.codex/auth.json` exists

### Tray icon not showing

Some desktop environments require additional packages:
```bash
# For GNOME with AppIndicator extension
sudo apt install gnome-shell-extension-appindicator
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Credits

- Inspired by [CodexBar](https://github.com/steipete/CodexBar) by Peter Steinberger
- Uses Anthropic and OpenAI OAuth APIs for real subscription data

## License

MIT License - see [LICENSE](LICENSE) file for details.
