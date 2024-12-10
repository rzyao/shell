#!/bin/bash

# 检查配置文件是否存在
CONFIG_FILE="/usr/local/etc/v2ray/config.json"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "配置文件不存在: $CONFIG_FILE"
    exit 1
fi

# 生成 UUID
generate_uuid() {
    cat /proc/sys/kernel/random/uuid
}

# 添加新用户到配置文件
add_user() {
    local email=$1
    local uuid=$(generate_uuid)

    # 更新配置文件
    jq --arg id "$uuid" --arg email "$email" \
    '.inbounds[0].settings.clients += [{"id": $id, "level": 1, "alterId": 0, "email": $email}]' \
    "$CONFIG_FILE" > tmp.json && mv tmp.json "$CONFIG_FILE"

    # 重新加载配置
    systemctl restart v2ray

    # 返回生成的 UUID
    echo "新用户已添加，UUID: $uuid"
}

# 主程序
read -p "请输入邮箱: " email
add_user "$email"
