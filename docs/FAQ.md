# 常见问题 FAQ

## 安装与运行问题

### Q: 安装后提示 `oc-update: command not found`
A: 这是因为npm全局bin目录不在你的PATH环境变量中，可以：
1. 重新登录终端，会自动加载npm路径
2. 或者手动添加到PATH：`echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc`
3. 使用pnpm/yarn/bun安装的用户同理，确保对应包管理器的全局bin目录在PATH中

### Q: 更新OMO后提示 `omo: command not found`
A: oc-update v1.2.0+已经自动解决这个问题：
- 更新OMO后会自动在对应包管理器的全局bin目录创建`omo`软链接
- 如果还是找不到，运行`hash -r`刷新命令缓存即可
- 或者手动创建：`ln -sf $(which oh-my-opencode) $(dirname $(which oh-my-opencode))/omo`

### Q: 版本检测不准确，已经安装最新版但显示旧版本
A: v1.2.0+已经优化了版本检测逻辑：
- 优先从`omo --version`/`opencode --version`命令输出获取版本
- 可以运行`oc-update config`查看当前检测到的安装路径是否正确
- 如果多路径安装冲突，建议卸载不需要的版本

## 功能使用问题

### Q: 如何完全禁用内置自动更新，只使用oc-update手动更新？
A: 运行：
```bash
oc-update disable all
```
这会同时禁用OpenCode和Oh-My-OpenCode的内置自动更新，之后可以定期运行`oc-update check`手动检查更新。

### Q: oc-update会不会修改我的环境变量？
A: 完全不会：
- 所有路径注入都只在脚本运行期间有效，完全不修改用户任何全局配置
- 不会修改~/.bashrc、~/.zshrc等配置文件
- 不会添加任何全局环境变量

### Q: 支持哪些包管理器？
A: 完全支持4种主流包管理器：
- ✅ npm
- ✅ pnpm
- ✅ yarn
- ✅ bun

自动检测OMO/OC是用哪种包管理器安装的，使用对应包管理器更新。

## 包名适配问题

### Q: Oh-My-OpenCode包名变更了，oc-update支持吗？
A: 完全支持：
- 新包名：`@code-yeongyu/oh-my-opencode`
- 旧包名：`oh-my-opencode`
- 自动识别新旧安装，不需要用户做任何配置变更

### Q: 旧版本OMO用户需要手动换包吗？
A: 不需要，oc-update会自动检测当前安装的是新包还是旧包，自动适配更新。

## 其他问题

### Q: 运行需要root权限吗？
A: 完全不需要，所有操作都是用户级别的，只会修改用户目录下的文件。

### Q: 支持哪些操作系统？
A: 支持所有类Unix系统：
- ✅ Linux (Ubuntu/Debian/CentOS/Fedora等)
- ✅ macOS
- ✅ WSL (Windows Subsystem for Linux)
- ❌ 原生Windows不支持（可以使用WSL）

### Q: 为什么获取更新日志失败？
A: 更新日志获取需要网络连接GitHub，如果访问GitHub失败：
- 可以配置GitHub镜像加速
- 或者直接访问项目仓库查看更新：https://github.com/gabrielslls/oc-update
