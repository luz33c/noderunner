#!/bin/bash

# Define USER and PASSWORD in global scope
USER=""
PASSWORD=""


# Function to display social media information
display_social_media() {
    echo -e "\033[0;34mYou can follow and communicate with me, and learn together through the following ways:\033[0m"
    echo -e "\033[0;32mTwitter:\033[0m \033[4;34mhttps://x.com/0x_onepiece\033[0m"
    echo -e "\033[0;32mMedium:\033[0m \033[4;34mhttps://medium.com/@0x_onepiece\033[0m"
    echo -e "\033[0;32mWebsite:\033[0m \033[4;34mhttp://noderunner.ninja\033[0m"
}

# Function to get username and password
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
    if [[ $confirmation != 'yes' && $confirmation != 'y' && $confirmation != 'Y' ]]
    then
        echo -e "\033[0;31mConfirmation failed. Exiting.\033[0m"
        exit 1
    fi
    echo -e "\033[0;32mConfirmed. Proceeding with installation.\033[0m"
}

# Main installation function
install_desktop() {
    sudo apt update && sudo apt install -y ubuntu-desktop xrdp
    if id "$USER" &>/dev/null; then
        echo "User $USER already exists."
    else
        sudo useradd -m -s /bin/bash $USER
        echo "$USER:$PASSWORD" | sudo chpasswd
        sudo usermod -aG sudo $USER
    fi
    echo "gnome-session" | sudo tee /home/$USER/.xsession
    sudo systemctl restart xrdp
    sudo systemctl enable xrdp
    sudo apt install -y wget
}

# Function to setup Google Chrome
setup_chrome() {
    sudo apt install -y gnupg
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
    sudo apt install -y google-chrome-stable
    echo "Google Chrome installed successfully."
}

# Function to setup Rivalz.ai
setup_rivalz_ai() {
    wget https://api.rivalz.ai/fragmentz/clients/rClient-latest.AppImage -O rClient-latest.AppImage
    chmod +x rClient-latest.AppImage
    sudo -u $USER mkdir -p /home/$USER/Documents
    sudo mv rClient-latest.AppImage /home/$USER/Documents/
    sudo chown $USER:$USER /home/$USER/Documents/rClient-latest.AppImage
    echo "Rivalz.ai rClient installed successfully."
}
# Function to allow user to choose options
user_options() {
    while true; do
        echo "Please select the installation option:"
        echo "1. Install only Chrome (for nodepay mining)"
        echo "2. Download Rivalz.ai client to the Documents directory (for Rivalz.ai mining)"
        echo "3. Install both"
        read -p "Enter your choice (1, 2, or 3): " option
        case $option in
            1)
                get_credentials
                install_desktop
                setup_chrome
                break
                ;;
            2)
                get_credentials
                install_desktop
                setup_rivalz_ai
                break
                ;;
            3)
                get_credentials
                install_desktop
                setup_chrome
                setup_rivalz_ai
                break
                ;;
            *)
                echo "Invalid input, please try again."
                ;;
        esac
    done
}
# # Function to allow user to choose options
# user_options() {
#     echo "Please select the installation option:"
#     echo "1. Install only Chrome (for nodepay mining)"
#     echo "2. Download Rivalz.ai client to the Documents directory (for Rivalz.ai mining)"
#     echo "3. Install both"
#     read -p "Enter your choice (1, 2, or 3): " option
#     case $option in
#         1)
#             get_credentials
#             install_desktop
#             setup_chrome
#             ;;
#         2)
#             get_credentials
#             install_desktop
#             setup_rivalz_ai
#             ;;
#         3)
#             get_credentials
#             install_desktop
#             setup_chrome
#             setup_rivalz_ai
#             ;;
#         *)
#             echo "Invalid input, script exiting."
#             exit 1
#             ;;
#     esac
# }

# Execute functions
display_social_media
user_options
display_social_media