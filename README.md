# oc-update

OpenCode 和 Oh-My-OpenCode 版本管理工具。

## 功能

- **版本检查**: 检查本地和远程版本对比
- **交互式更新**: 检查后询问是否更新
- **直接更新**: 跳过询问直接更新
- **自动更新管理**: 启用/禁用 OC/OMO 的自动更新检查
- **多包管理器支持**: 自动检测 npm/pnpm/yarn/bun
- **智能路径发现**: 自动定位实际运行的版本
- **零环境配置**: 脚本内部自动注入包管理器路径，不需要修改用户全局环境变量
- **OMO自动别名**: 安装/更新OMO后自动创建`omo`命令别名，无需手动配置
- **增强版本检测**: 优先从命令行输出版本获取，比读package.json更准确
- **OMO新包名适配**: 支持新包名`@code-yeongyu/oh-my-opencode`，向后兼容旧包名

## 安装

### 方法 1: npm/pnpm/yarn/bun 全局安装（推荐）

```bash
# npm
npm install -g gabrielslls/oc-update

# pnpm
pnpm add -g gabrielslls/oc-update

# yarn
yarn global add gabrielslls/oc-update

# bun
bun add -g gabrielslls/oc-update

# 本地开发安装
npm install -g .
```

### 方法 2: 手动安装（不需要Node.js环境）

直接下载脚本到用户本地bin目录：

```bash
# 下载最新版本
curl -fsSL https://raw.githubusercontent.com/gabrielslls/oc-update/main/bin/oc-update -o ~/.local/bin/oc-update

# 添加执行权限
chmod +x ~/.local/bin/oc-update

# 确保~/.local/bin在PATH中
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

### 验证安装

```bash
oc-update --version
# 输出: oc-update v1.2.0
```

## 用法

```bash
oc-update check          # 检查更新，有更新时询问是否更新
oc-update check --oc     # 仅检查 OpenCode
oc-update check --omo    # 仅检查 Oh-My-OpenCode

oc-update update         # 直接更新，不询问
oc-update update --oc    # 仅更新 OpenCode

oc-update disable all    # 禁用自动更新检查
oc-update disable oc     # 仅禁用 OpenCode 自动更新
oc-update disable omo    # 仅禁用 Oh-My-OpenCode 自动更新

oc-update enable all     # 启用自动更新检查
oc-update enable oc      # 仅启用 OpenCode 自动更新
oc-update enable omo     # 仅启用 Oh-My-OpenCode 自动更新

oc-update config         # 显示当前配置和安装路径
```

## 特性详解

### 多包管理器支持

自动检测并使用正确的包管理器：

| 包管理器 | 检测方式 |
|----------|----------|
| npm | 默认 |
| pnpm | `pnpm list -g` 成功 |
| yarn | `yarn global list` 包含目标包 |
| bun | `~/.bun/install/global` 存在 |

### 智能路径发现

当存在多个安装位置时，脚本会按以下优先级定位实际运行的版本：

1. **命令路径反推**: 解析 `command -v opencode` 的符号链接，找到实际运行的版本
2. **npm list 查询**: 使用 `npm list -g --parseable` 获取安装路径
3. **常见路径搜索**: 搜索 `~/.local`、NVM、fnm、bun、系统级等常见位置

支持的安装位置：

- `~/.local/lib/node_modules` (手动安装)
- `~/.nvm/versions/node/*/lib/node_modules` (NVM)
- `~/.fnm/node-versions/*/installation/lib/node_modules` (fnm)
- `~/.bun/install/global/node_modules` (bun)
- `/usr/local/lib/node_modules` (系统级)
- `/usr/lib/node_modules` (Debian 系统级)

### 更新验证

更新后自动验证版本，如果版本不匹配会提示：
```
⚠ 更新完成，但版本验证失败
  预期: 1.3.13, 实际: 1.3.7
  可能需要重新登录或运行 'hash -r' 刷新 PATH 缓存
```

### 零配置运行

脚本完全不需要修改用户全局环境变量：
- 启动时自动检测pnpm/npm/yarn/bun的全局bin目录，临时注入到脚本内部PATH
- 即使环境变量中没有包管理器路径，脚本也能正常找到`omo`/`opencode`命令
- 所有修改都只在脚本运行期间生效，不影响用户其他操作

### OMO自动别名创建

安装/更新Oh-My-OpenCode后自动创建`omo`命令别名：
- 自动识别当前使用的包管理器，在对应全局bin目录创建软链接
- 同时创建`omo`和`oh-my-opencode`两个别名，指向官方原生可执行文件
- 支持pnpm/npm/yarn/bun所有包管理器，无需用户手动配置

### 增强版本检测

版本检测更准确，避免"安装了最新版但检测到旧版本"的问题：
- 优先级最高：直接从`omo --version`/`opencode --version`命令输出版本获取
- 备选方案：从安装目录的package.json读取版本
- OMO特殊处理：自动尝试新旧包名获取远程版本

### OMO新包名适配

完美适配Oh-My-OpenCode包名变更：
- 新包名：`@code-yeongyu/oh-my-opencode`
- 旧包名：`oh-my-opencode`
- 自动识别新旧安装，路径检测、包管理器检测、版本获取都同时支持新旧包名
- 平滑迁移，无需用户手动修改配置

## 配置文件

工具直接读写 OC/OMO 的原生配置文件：

| 包 | 配置文件 | 配置项 |
|---|---------|-------|
| OpenCode | `~/.config/opencode/opencode.json` | `autoupdate: true/false/"notify"` |
| Oh-My-OpenCode | `~/.config/opencode/oh-my-opencode.json` | `auto_update: true/false` + `disabled_hooks: ["auto-update-checker"]` |

## 自动更新机制说明

### OpenCode

- 配置项: `autoupdate`
- 值: `true` (自动更新) | `false` (禁用) | `"notify"` (仅通知)
- 环境变量: `OPENCODE_DISABLE_AUTOUPDATE=1` 也可禁用

### Oh-My-OpenCode

- 配置项: `auto_update` + `disabled_hooks`
- `auto_update: false` 禁用自动更新
- `disabled_hooks: ["auto-update-checker"]` 禁用更新检查 hook

详见 [docs/opencode-autoupdate.md](docs/opencode-autoupdate.md)

## 依赖

- `npm` - 用于查询和安装包
- `jq` - JSON 解析 (可选，无 jq 时使用 sed/grep 回退)
- `gh` - GitHub CLI (可选，用于获取更新日志)

## 示例输出

### 版本检查

```
$ oc-update check

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📦 版本检查
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

OpenCode (opencode-ai)
─────────────────────────────────────
  本地: 1.2.24  远程: 1.2.25
  🆕 有更新

  更新内容:
    • Fix memory leak in agent sessions
    • Add new --dry-run flag

Oh-My-OpenCode (oh-my-opencode)
─────────────────────────────────────
  本地: 3.11.2  远程: 3.11.2
  ✓ 已是最新

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

发现 1 个可更新的包

  更新 OpenCode? [y/N] y
  检测到包管理器: npm
  执行: npm install --prefix /home/user/.local -g opencode-ai
✓ OpenCode 更新成功 (v1.2.25)
```

### 配置查看

```
$ oc-update config

当前配置
─────────────────────────────────────
OpenCode:
  autoupdate: false
  包管理器: npm
  安装路径: /home/user/.local/lib/node_modules/opencode-ai

Oh-My-OpenCode:
  auto_update: false
  包管理器: npm
  安装路径: /home/user/.nvm/versions/node/v20.20.2/lib/node_modules/oh-my-opencode
  disabled_hooks: 包含 "auto-update-checker"
```

## Changelog

见 [CHANGELOG.md](CHANGELOG.md)

## License

MIT
