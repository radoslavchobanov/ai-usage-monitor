# Changelog

All notable changes to AI Usage Monitor will be documented in this file.

## [3.1.0] - 2025-02-03

### Added
- Dark and Light theme support
- Settings dialog for theme switching
- New modern tray icon design (three-bar meter)
- New app icon (stylized bar chart)
- Professional UI/UX with proper contrast
- Skip taskbar/pager hints for popup window

### Changed
- Reverted to tabbed interface (from drill-down navigation)
- Improved color contrast in both themes
- Better window positioning near system tray
- Updated icon generator with rounded rectangles

### Fixed
- Theme persistence across app restarts
- Window focus handling

## [3.0.0] - 2025-02-02

### Added
- KDE Plasma-style UI (experimental)
- Drill-down navigation between providers

### Changed
- Complete UI rewrite with dark theme

## [2.2.0] - 2025-02-02

### Added
- Real OAuth API integration for Claude
- Real OAuth API integration for Codex/ChatGPT
- Model-specific usage tracking (Sonnet, Opus, Haiku)
- Extra usage/overage tracking
- Pace indicator for usage sustainability

### Changed
- Switched from local file parsing to OAuth APIs
- More accurate subscription usage data

## [2.0.0] - 2025-02-01

### Added
- Tabbed interface for multiple providers
- Visual progress bars with color coding
- Cost tracking and estimates
- System tray integration with AppIndicator

### Changed
- Complete UI redesign inspired by CodexBar

## [1.0.0] - 2025-02-01

### Added
- Initial release
- Basic Claude usage monitoring
- CLI status display
- Simple GTK window
