#!/bin/bash

# 检查内核版本
KERNEL_VERSION=$(uname -r)
REQUIRED_VERSION="4.9"

# 比较内核版本
if [[ "$(printf '%s\n' "$REQUIRED_VERSION" "$KERNEL_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]]; then
    echo "当前内核版本是 $KERNEL_VERSION，支持 BBR。"
else
    echo "当前内核版本是 $KERNEL_VERSION，不支持 BBR。请更新内核。"
    exit 1
fi

# 启用 BBR
echo "启用 BBR 加速..."
{
    echo "net.core.default_qdisc = fq"
    echo "net.ipv4.tcp_congestion_control = bbr"
} | sudo tee -a /etc/sysctl.conf

# 应用更改
sudo sysctl -p

# 验证 BBR 是否启用
TCP_CONGESTION_CONTROL=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
if [ "$TCP_CONGESTION_CONTROL" == "bbr" ]; then
    echo "BBR 已成功启用。"
else
    echo "BBR 启用失败。"
fi

# 检查 BBR 模块
if lsmod | grep -q bbr; then
    echo "BBR 模块正在运行。"
else
    echo "BBR 模块未加载。"
fi
