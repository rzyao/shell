#!/bin/bash

# 安装 V2Ray
echo "正在安装 V2Ray..."
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

# 更新 geoip.dat 和 geosite.dat
echo "正在更新 geoip.dat 和 geosite.dat..."
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)

# 读取用户输入
read -p "请输入访问端口 (建议使用 443): " port
read -p "请输入 uuid: " uuid
read -p "请输入伪装路径: " ws_path
read -p "请输入伪装域名: " domain

# 生成 config.json 文件
cat <<EOL > /usr/local/etc/v2ray/config.json
{
    "log": {
        "access": "/var/log/v2ray/access.log",
        "error": "/var/log/v2ray/error.log",
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "listen": "127.0.0.1",
            "port": $port,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid",
                        "level": 1,
                        "alterId": 0
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "tls",
                "wsSettings": {
                    "path": "$ws_path"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {}
        },
        {
            "protocol": "blackhole",
            "settings": {},
            "tag": "blocked"
        }
    ],
    "routing": {
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "blocked"
            }
        ]
    }
}
EOL

echo "config.json 文件已生成在 /usr/local/etc/v2ray/config.json"

# 启动 V2Ray
echo "正在启动 V2Ray..."
systemctl start v2ray

# 设置 V2Ray 开机自启动
echo "正在设置 V2Ray 开机自启动..."
systemctl enable v2ray

# 测试 V2Ray 配置
echo "正在测试 V2Ray 配置..."
v2ray test -config /usr/local/etc/v2ray/config.json

# 开启 BBR 加速
echo "正在开启 BBR 加速..."
bash <(curl -L https://raw.githubusercontent.com/rzyao/shell/main/bbr.sh)

# 生成分享链接
share_link=$(cat <<EOL
{
    "port": 443,
    "ps": "v2ray",
    "tls": "tls",
    "id": "$uuid",
    "aid": 0,
    "v": 2,
    "host": "$domain",
    "type": "none",
    "path": "$ws_path",
    "net": "ws",
    "add": "$domain",
    "allowInsecure": 0,
    "method": "none",
    "peer": "$domain",
    "sni": "$domain"
}
EOL
)

# Base64 编码分享链接
encoded_link=$(echo -n "$share_link" | base64 | tr -d '\n')

# 输出分享链接
echo "生成的分享链接如下："
echo "vmess://$encoded_link"

# 提示用户配置 Nginx 反向代理和 HTTPS
echo "所有步骤已完成。"
echo "请配置 Nginx 反向代理，伪装域名的证书，并开启 HTTPS。"
echo "确保您的域名已正确解析到服务器 IP。"
