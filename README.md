# oc-update

OpenCode 和 Oh-My-OpenCode 版本管理工具。

## 功能

- **版本检查**: 检查本地和远程版本对比
- **交互式更新**: 检查后询问是否更新
- **直接更新**: 跳过询问直接更新
- **自动更新管理**: 启用/禁用 OC/OMO 的自动更新检查

## 安装

通过 npm 全局安装：

```bash
# 从 GitHub 安装
npm install -g gabrielslls/oc-update

# 或者本地安装
npm install -g .
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

oc-update config         # 显示当前配置
```

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
正在更新 OpenCode 到 1.2.25...
✓ OpenCode 更新成功
```

## License

MIT
