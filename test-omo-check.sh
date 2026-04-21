#!/usr/bin/env bash
# Test script to debug OMO detection

# Source oc-update's functions (we'll copy-paste the relevant ones)
OC_PKG="opencode-ai"
OMO_PKG_OLD="oh-my-opencode"
OMO_PKG_NEW="@code-yeongyu/oh-my-opencode"
OMO_PKG="$OMO_PKG_NEW"
OC_NAME="OpenCode"
OMO_NAME="Oh-My-OpenCode"

# Copy get_local_version here
get_local_version() {
    local pkg="$1"
    echo "DEBUG get_local_version called with pkg: $pkg"
    
    # 优先级最高：直接从运行的命令获取版本（最准确）
    local cmd_name=""
    [[ "$pkg" == "opencode-ai" ]] && cmd_name="opencode"
    [[ "$pkg" == "$OMO_PKG_OLD" || "$pkg" == "$OMO_PKG_NEW" ]] && cmd_name="omo"
    echo "DEBUG cmd_name: $cmd_name"
    
    if [[ -n "$cmd_name" && -x $(command -v "$cmd_name" 2>/dev/null) ]]; then
        echo "DEBUG command -v $cmd_name: $(command -v "$cmd_name")"
        local cmd_version
        cmd_version=$($cmd_name --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        echo "DEBUG cmd_version: $cmd_version"
        if [[ -n "$cmd_version" ]]; then
            echo "$cmd_version"
            return
        fi
    fi
    
    # 命令不存在，直接返回未安装，不遍历文件系统避免卡顿
    echo "not-installed"
}

echo "=== Testing get_local_version with OMO_PKG_NEW ==="
get_local_version "$OMO_PKG_NEW"
echo -e "\n=== Testing get_local_version with OMO_PKG_OLD ==="
get_local_version "$OMO_PKG_OLD"
