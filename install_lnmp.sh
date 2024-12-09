#!/bin/bash

# 更新系统
echo "更新系统..."
sudo apt update && sudo apt upgrade -y

# 安装 Nginx
echo "安装 Nginx..."
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# 安装 MySQL
echo "安装 MySQL..."
sudo apt install mysql-server -y
sudo mysql_secure_installation

# 安装 PHP 及其扩展
echo "安装 PHP..."
sudo apt install php-fpm php-mysql -y

# 配置 Nginx 使用 PHP
echo "配置 Nginx..."
sudo sed -i 's/index index.html/index index.php index.html/g' /etc/nginx/sites-available/default
sudo bash -c 'cat <<EOT >> /etc/nginx/sites-available/default

location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/var/run/php/php7.4-fpm.sock; # 根据你的 PHP 版本调整
}
EOT'

# 测试配置并重启 Nginx
echo "测试 Nginx 配置..."
sudo nginx -t
sudo systemctl restart nginx

# 创建 PHP 测试文件
echo "创建 PHP 测试文件..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

echo "LNMP 安装完成！请访问 http://你的服务器IP/info.php 测试。"
