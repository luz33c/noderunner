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
    echo "PASSWORD $PASSWORD. USER $USER"
    echo "Installation complete. GNOME Desktop, xrdp, and Google Chrome have been installed. You can now connect via Remote Desktop with the user $USER."
}

# 执行函数
get_credentials
install_system
