#!/bin/bash

# 更新包列表并安装expect工具
sudo apt update
sudo apt install -y expect

# 创建一个自动化输入用户名和密码的expect脚本
cat > setup_xrdp.exp <<EOF
#!/usr/bin/expect

# 设置脚本超时时间
set timeout -1

# 启动原始脚本
spawn bash setup_xrdp.sh

# 等待提示输入用户名
expect "Please enter a username for remote desktop access:"
# 提供用户名
send "your_username\r"

# 等待提示输入密码
expect "Please enter a password for remote desktop access:"
# 提供密码
send "your_password\r"

# 等待脚本执行完成
expect eof
EOF

# 创建安装脚本
cat > setup_xrdp.sh <<'EOF'
#!/bin/bash

echo "Please enter a username for remote desktop access:"
read USER
echo "Please enter a password for remote desktop access:"
read -s PASSWORD  # The -s option hides the input for privacy

# 更新包列表
sudo apt update

# 安装 GNOME 桌面环境
sudo apt install -y ubuntu-desktop

# 安装 xrdp
sudo apt install -y xrdp

# 添加用户并设置密码
sudo useradd -m -s /bin/bash $USER
echo "$USER:$PASSWORD" | sudo chpasswd

# 将用户添加到sudo组
sudo usermod -aG sudo $USER

# 配置 xrdp 使用 GNOME 桌面
echo "gnome-session" > ~/.xsession

# 重启 xrdp 服务
sudo systemctl restart xrdp

# 设置 xrdp 开机自启
sudo systemctl enable xrdp

# 安装 Google Chrome 的必要依赖
sudo apt install -y wget gnupg

# 添加 Google 仓库密钥
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# 添加 Google Chrome 仓库
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# 再次更新包列表
sudo apt update

# 安装 Google Chrome
sudo apt install -y google-chrome-stable

echo "Installation complete. GNOME Desktop, xrdp, and Google Chrome have been installed. You can now connect via Remote Desktop with the user $user."
EOF

# 使expect脚本可执行
chmod +x setup_xrdp.exp

# 运行expect脚本
./setup_xrdp.exp
