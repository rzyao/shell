#!/bin/bash

# 定义脚本的 URL
SCRIPT_URL="https://raw.githubusercontent.com/rzyao/shell/refs/heads/main/v2ray_add_user.sh"
SCRIPT_PATH="/usr/local/bin/v2ray_add_user.sh"

# 下载脚本
echo "正在下载 v2ray_add_user.sh ..."
curl -o "$SCRIPT_PATH" "$SCRIPT_URL"

# 赋予执行权限
echo "赋予执行权限 ..."
chmod +x "$SCRIPT_PATH"

# 创建命令别名
echo "创建命令别名 ..."
if ! grep -q "alias add='$SCRIPT_PATH'" ~/.bashrc; then
    echo "alias add='$SCRIPT_PATH'" >> ~/.bashrc
    echo "命令别名已添加到 ~/.bashrc"
else
    echo "命令别名已存在"
fi

# 使更改生效
echo "使更改生效 ..."
source ~/.bashrc

echo "安装和设置完成！您可以通过输入 'add' 来运行脚本。"
