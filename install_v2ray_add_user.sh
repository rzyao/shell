#!/bin/bash

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # 无颜色

# 定义脚本的 URL
SCRIPT_URL="https://raw.githubusercontent.com/rzyao/shell/refs/heads/main/v2ray_add_user.sh"
SCRIPT_PATH="/usr/local/bin/v2ray_add_user.sh"

# 下载脚本
echo -e "${YELLOW}正在下载 v2ray_add_user.sh ...${NC}"
curl -o "$SCRIPT_PATH" "$SCRIPT_URL"

# 赋予执行权限
echo -e "${YELLOW}赋予执行权限 ...${NC}"
chmod +x "$SCRIPT_PATH"

# 创建命令别名
echo -e "${YELLOW}创建命令别名 ...${NC}"
if ! grep -q "alias add='$SCRIPT_PATH'" ~/.bashrc; then
    echo "alias add='$SCRIPT_PATH'" >> ~/.bashrc
    echo -e "${GREEN}命令别名已添加到 ~/.bashrc${NC}"
else
    echo -e "${GREEN}命令别名已存在${NC}"
fi

# 提示用户手动使更改生效
echo -e "${YELLOW}请运行以下命令以使更改生效：${NC}"
echo -e "${GREEN}source ~/.bashrc${NC}"

echo -e "${GREEN}安装和设置完成！您可以通过输入 'add' 来运行脚本。${NC}"
