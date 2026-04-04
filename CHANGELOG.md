# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-04-04

### Added

- **Multi-package manager support**: Now detects and uses npm, pnpm, yarn, or bun based on your environment
- **Dynamic path discovery**: Automatically finds the actual running version by resolving `command -v` symlinks
- **Multi-installation location support**: Searches across common paths:
  - `~/.local/lib/node_modules` (manual install)
  - NVM paths (`~/.nvm/versions/node/*/lib/node_modules`)
  - fnm paths (`~/.fnm/node-versions/*/installation/lib/node_modules`)
  - bun global (`~/.bun/install/global/node_modules`)
  - System paths (`/usr/local/lib`, `/usr/lib`)
- **Post-update verification**: Validates version after update and warns if PATH issues detected
- **Enhanced `config` command**: Now displays package manager and installation path for each package

### Fixed

- **Critical bug**: Updates were installed to wrong location when multiple npm global paths existed
  - Previously: `npm install -g` always used npm's default global root (e.g., NVM path)
  - Now: Detects where the package is actually installed and updates to the correct location
- **Version detection**: Hardcoded `~/.local` path replaced with dynamic discovery
- **Symlink resolution**: Properly follows symlinks to find actual binary location

### Changed

- `find_package_path()` priority order:
  1. `command -v` resolution (actual running version)
  2. `npm list -g` query
  3. Search common installation paths
- `update_package()` now shows the install command being executed

## [1.0.0] - 2025-03-30

### Added

- Initial release
- Version check for OpenCode and Oh-My-OpenCode
- Interactive update prompts
- Direct update mode
- Auto-update configuration management
- Changelog fetching via GitHub CLI
- Configuration display command
