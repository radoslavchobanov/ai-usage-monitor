# Changelog

All notable changes to PlasmaCodexBar will be documented in this file.

## [1.0.0] - 2026-02-04

### Added
- Native KDE Plasma 6 system tray widget
- Provider tabs with Claude and OpenAI logos
- Session and weekly usage tracking with progress bars
- Models section showing per-model usage
- Extra usage section for overage tracking
- Cost section with estimated spending
- Quick links to provider dashboards
- Embedded Python backend for API calls
- Support for KDE Store distribution (.plasmoid package)

### Changed
- Renamed project from "AI Usage Monitor" to "PlasmaCodexBar"
- Complete rewrite as native Plasma 6 QML widget
- Uses P5Support.DataSource for backend communication

### Technical
- Plasma 6 compatible with X-Plasma-API-Minimum-Version: 6.0
- KPackageStructure: Plasma/Applet
- Embedded backend script in plasmoid package
