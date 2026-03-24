# OpenCode 自动更新原理与禁用方法

## 更新机制

OpenCode 默认在**启动时自动检查并下载新版本**：
- 启动时连接更新服务器检查新版本
- 如果有新版本，在**下次启动**时应用更新
- 自动下载在后台进行

## 禁用自动更新的方法

### 方法 1: 配置文件（推荐）

在 `~/.config/opencode/opencode.json` 或项目根目录的 `opencode.json` 中添加：

```json
{
  "autoupdate": false
}
```

> **注意**：根据 GitHub Issue #3412，`autoupdate: false` 在本地配置文件（项目目录）中可能被忽略，建议放在**全局配置**中。

**其他选项**：
```json
{
  "autoupdate": "notify"  // 禁用更新但提示新版本可用
}
```

### 方法 2: 环境变量

```bash
export OPENCODE_DISABLE_AUTOUPDATE=1
```

这个方法在 Issue #1793 中被添加，专门为使用包管理器（如 bun）管理 OpenCode 的用户设计。

## 配置优先级

配置文件加载顺序（后者覆盖前者）：

1. Remote (`.well-known/opencode`)
2. **Global** (`~/.config/opencode/opencode.json`) ← 建议放这里
3. Custom (`OPENCODE_CONFIG` 环境变量)
4. Project (`opencode.json`)
5. Inline (`OPENCODE_CONFIG_CONTENT` 环境变量)

## 已知问题

| Issue | 描述 |
|-------|------|
| #3412 | `autoupdate: false` 在本地项目配置中可能被忽略 |
| #10484 | 即使设置 `OPENCODE_DISABLE_AUTOUPDATE=1`，仍可能尝试安装包 |

## 最可靠的禁用方式

1. 在 `~/.config/opencode/opencode.json` 设置 `"autoupdate": false`
2. 同时设置环境变量 `OPENCODE_DISABLE_AUTOUPDATE=1`

## 参考来源

- 官方文档：https://opencode.ai/docs/config/
- GitHub Issues：#1793, #3412, #10484
