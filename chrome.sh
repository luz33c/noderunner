#!/bin/bash

# 全局变量定义
USER=""
PASSWORD=""

# 定义获取用户名和密码的函数
get_credentials() {
    echo -e "\033[0;34mPlease enter a username for remote desktop access:\033[0m"
    read USER < /dev/tty
    echo -e "\033[0;34mPlease enter a password for remote desktop access:\033[0m"
    read -s PASSWORD < /dev/tty
    echo ""
    echo -e "\033[0;33mPlease confirm your username and password.\033[0m"
    echo "Username: $USER"
    echo -e "Password: \033[0;31m$PASSWORD\033[0m"
    echo -e "\033[0;32mIf correct, type 'yes' or 'y' to continue:\033[0m"
    read confirmation < /dev/tty
    if [[ $confirmation == 'yes' || $confirmation == 'y' || $confirmation == 'Y' ]]
    then
        echo -e "\033[0;32mConfirmed. Proceeding with installation.\033[0m"
    else
        echo -e "\033[0;31mConfirmation failed. Exiting.\033[0m"
        exit 1
    fi
}


# 主安装程序
install_system() {
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

    echo "Installation complete. GNOME Desktop, xrdp, and Google Chrome have been installed. You can now connect via Remote Desktop with the user $USER."
}

# 执行函数
get_credentials
install_system
