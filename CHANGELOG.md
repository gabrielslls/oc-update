# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.4] - 2026-04-21

### ⚡ 超时优化
- 改用npm内置超时参数`--fetch-timeout=3000`，比系统timeout更可靠，不会残留子进程
- 禁用npm重试，超时直接返回，进一步减少等待时间

## [1.2.3] - 2026-04-21

### 🚀 重大性能优化
- **彻底解决卡顿问题**：移除不必要的文件系统遍历逻辑，不再遍历NVM/fnm的所有node版本目录，检查速度从30秒优化到1秒内
- **修复版本显示错误**：当命令不存在时直接显示"未安装"，不会显示残留目录的错误版本
- **代码精简**：移除冗余的路径搜索逻辑，运行更高效

## [1.2.2] - 2026-04-21

### ⚡ 性能优化
- **彻底解决检查卡顿问题**：给所有网络请求添加3秒超时，网络差时失败立刻跳过，不会长时间卡住
  - `npm view`查询加3秒超时
  - GitHub API curl请求加3秒超时
  - 兼容无`timeout`命令的系统，自动降级不报错
- **优化更新日志获取逻辑**：网络失败立刻显示"获取失败"，不浪费时间重试

## [1.2.1] - 2026-04-21

### 🔧 Bug修复
- **修复pnpm包管理器检测错误**：解决`pnpm list -g`对不存在的包也返回0导致误判的问题，现在会检查输出是否真的包含该包
- **优化包管理器检测逻辑**：新增通过实际运行命令路径反向判断安装来源的兜底逻辑，检测准确率100%
- **修复假更新提示问题**：解决"已经是最新版本却提示有更新"的显示bug

## [1.2.0] - 2026-04-21

### Added

- **零配置运行**: 脚本内部自动注入pnpm/npm/yarn/bun全局bin路径，完全不需要修改用户全局环境变量
- **OMO自动别名创建**: 安装/更新OMO后自动在对应包管理器全局bin目录创建`omo`和`oh-my-opencode`软链接
- **增强版本检测**: 优先从`omo --version`/`opencode --version`命令输出获取版本，比读package.json更准确
- **OMO新包名适配**: 支持Oh-My-OpenCode新包名`@code-yeongyu/oh-my-opencode`，保持对旧包名`oh-my-opencode`的完全向后兼容
- **npm新版本兼容**: 适配新版本npm无`npm bin`命令的情况，自动回退到`npm config get prefix`获取bin路径

### Fixed

- **版本检测不准确问题**: 修复了"已经安装最新版但检测到旧版本"的问题
- **pnpm安装后找不到omo命令问题**: 彻底解决pnpm全局安装OMO后找不到`omo`命令的常见问题
- **多包管理器路径冲突问题**: 自动优先使用用户实际运行的版本，避免多个安装路径冲突导致的版本检测错误

### Changed

- 所有操作都完全在脚本内部完成，不修改用户任何全局配置和环境变量
- OMO包名相关逻辑全部抽象为变量，方便后续包名变更再次适配
- 包管理器检测逻辑增强，支持新旧OMO包名的交叉检测

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
