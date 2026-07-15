# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.9.0] - 2026-07-15

### Fixed (Root Cause)
- **OMO 缓存版本不一致的根源**: OpenCode 从 `~/.cache/opencode/node_modules/` 加载 OMO 插件，
  但 `oc-update` 只更新全局安装。缓存同步是可选提示（y/N，30s超时默认N），导致用户升级后
  OpenCode 仍使用旧版本。详见 `docs/FAQ.md`。

### Changed
- **`_prompt_sync_omo_cache` → `_sync_omo_cache`**: 替换为自动同步（无提示），
  使用精确版本号（`oh-my-openagent@4.18.1`）而非 `@latest`，避免 registry tag 漂移
- **缓存同步覆盖所有更新路径**: 不再限于 bun 分支，npm/pnpm/yarn 更新 OMO 后也会自动同步缓存
- **`config --fix` 子命令**: 新增 `oc-update config --fix` 一键修复缓存版本不一致 + 清理旧包名
- **`do_auto` Stage 3 自动修复**: 自动维护模式下缓存版本不一致也会自动修复

### Added
- **`OC_NO_CACHE_SYNC=1` 环境变量**: 允许跳过自动缓存同步
- **同步后版本验证**: `_sync_omo_cache` 执行后验证缓存版本是否确实更新到目标版本
- **不降级保护**: 缓存版本比全局新时跳过同步（防止用户手动升级缓存后被降级）
- **缓存初始化检查**: 缓存无 `package.json`/`bun.lock` 时跳过同步

## [1.8.0] - 2026-06-10

### Added
- **`do_auto()` 自动维护模式**: 新增 `auto` 子命令，4 阶段无人值守自动维护
  （环境准备 → 扫描 → 自动修复 → 验证/报告），幂等设计，适合定时任务
- **`--dry-run` 和 `--force` 标志**: 全局参数解析，支持试运行模式

### Fixed
- **OMO 升级在 arm64 平台失败**: bunx 在临时隔离环境中运行，找不到全局预装的
  平台二进制包 (oh-my-openagent-linux-arm64)。改用 bun add -g + 手动 postinstall
  替代 bunx，bun add -g 直接安装到全局目录，自动解析 optionalDependencies 中
  的平台二进制包，安装后自动信任并运行 postinstall.mjs

### Changed
- **`_ensure_bun()` 提取复用**: 从 `do_bootstrap()` 提取为独立函数
- **OMO 安装/更新自动安装 bun**: 缺失时自动调用 `_ensure_bun()`，移除 npx 降级路径
- **`_safe_capture()` 辅助函数**: 消除 `set -e` + `local var=$(func)` 系统性 bug
- **`bunx --bun` 修复 ESM shebang**: 某些平台 bunx 使用 node 运行，导致 ESM import 失败

## [1.7.0] - 2026-06-02

### Added
- **`_ensure_bun()` 函数**: 从 `do_bootstrap()` 提取为独立可复用函数，npm registry → bun.sh → 二进制直链三层策略
- **OMO 更新/安装自动安装 bun**: `update_package()` / `do_install()` 中 OMO 路径在 bun 缺失时自动调用 `_ensure_bun()` 安装
- **PATH 残留检测**: `_check_stale_shadowing(pkg, cmd_name)` 扫描所有安装位置的同名命令，发现低版本残留时生成精确的 PM 卸载命令
- **残留检测集成**: `update_package()` 更新后自动检查影子，`show_config()` 展示修复命令，`show_summary()` 显示一行概要
- **PM 感知卸载命令**: 根据安装路径自动推断来源 PM: `~/.bun/*` → `bun remove -g`, `pnpm/*` → `pnpm remove -g`, 等等

### Removed
- **OMO 的 npx 降级路径**: OMO v4.6.0+ 硬依赖 bun，不再使用 npx fallback（npx 启动 OMO 安装器后内部 `spawnSync bun` 仍会 ENOTFOUND）
- **`do_bootstrap()` 内联 bun 安装**: 全部替换为复用 `_ensure_bun()`

## [1.6.0] - 2026-06-02

### Added
- **缓存版本检测**: `find_all_installations()` 现在扫描 OpenCode 插件缓存 (`~/.cache/opencode/node_modules/`)
- **缓存一致性检查**: `show_config()` 新增缓存诊断区块，比对缓存 OMO 版本 vs 全局安装版本
- **旧包名残留检测**: 自动检测缓存中是否残留 `oh-my-opencode`（已更名为 `oh-my-openagent`）
- **TUI 配置漂移检测**: 检查 `tui.json` 是否包含 `oh-my-openagent/tui` 必要条目
- **快速摘要警告**: `oc-update` 无参数运行时，发现缓存问题会显示简短警告

## [1.5.0] - 2026-06-02

### Added
- **`bootstrap` 子命令**: 从零安装，自动检测并安装 bun（如缺失），再装 OpenCode + OMO
  - bun 安装脚本通过 `get_url` 走 GitHub 代理链下载（中国网络可用），直连兜底
  - 安装后自动将 `~/.bun/bin` 加入当前会话 PATH
- **默认无参数显示摘要**: 直接运行 `oc-update` 显示简洁版本信息、包管理器和安装路径
- **OMO 版本锁定支持**: `oc-update install --omo 4.6.0` 通过 `bunx oh-my-openagent@4.6.0 install` 实现
- **OMO 安装器新增 flags**: 适配 v4.6.0 新增的 `--claude=no --gemini=no --copilot=no` 参数

### Changed
- **OMO 更新/安装改用 `bunx` 官方安装器**: 弃用 `bun add -g` / `npm install -g` 路径
  - OMO 是 OpenCode 插件，必须通过官方安装器注册到 plugin 列表
  - 无 bun 时自动降级到 `npx`，两者都不可用时硬错误提示
- **bunx/npx OMO 调用包装 registry fallback**: `BUN_CONFIG_REGISTRY` 环境变量注入，遍历 npmmirror → USTC → npmjs.org
  - 重试间清理 `~/.bun/install/cache/oh-my-openagent` 缓存
- **`update_package()` OMO 路径重构**:
  - 新增 `omo_pkg_spec` 变量支持版本锁定
  - 移除 PM 全局安装降级路径（不再 `npm install -g oh-my-openagent`）
  - 失败时返回硬错误 + 引导提示

### Fixed
- **`load_nvm()` 触发 `set -e` 导致 `update_package()` 静默退出**: `load_nvm` 末尾 `return 1` 在没有 nvm 的机器上导致函数中断，改为 `load_nvm || true`
- **OMO 安装器 flags 兼容性**: `--skip-auth` 在 v4.6.0 中被废弃，新增 `--claude=no --gemini=no --copilot=no`

### Network (中国网络优化)
- **无包管理器安装 OC**: 新增三层 fallback 链
  1. 直连 `opencode.ai/install`（VPN 用户）
  2. `get_url()` 从 GitHub raw 下载安装脚本（5 节点代理链）
  3. 全部失败→打印 bun/npm+镜像/手动下载等多种替代方案

## [1.2.7] - 2026-04-21

### 🐛 修复检测bug
- **解决OMO已安装但显示未安装的问题**：
  1. 合并stderr和stdout捕获版本号，解决部分CLI将版本输出到stderr导致获取不到的问题
  2. 支持带v前缀的版本号格式（比如v3.17.4）
  3. 新增尝试`-v`参数获取版本，兼容不同CLI规范
  4. 优化路径判断严谨性，避免路径包含空格时出错

## [1.2.6] - 2026-04-21

### 🏁 最终优化
- 修复OMO未安装场景依然获取更新日志的bug，再节省3秒超时时间
- 现在网络完全不通的场景下，最慢9秒完成检查，比最初的30秒快70%
- 网络正常的场景下，1秒内完成检查，体验极佳

## [1.2.5] - 2026-04-21

### 🚀 极致速度优化
- 新增未安装场景优化：首次安装时不获取更新日志，节省2次网络请求，最多快6秒
- 优化timeout参数为`-k 1s 3s`，超时后强制杀死进程，绝对不会卡住

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
