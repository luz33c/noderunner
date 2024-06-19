#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root."
    echo "Please try using 'sudo -i' to switch to the root user, then run this script again."
    exit 1
fi

# Node installation function
function install_node() {
# Get the runtime file
read -p "Please enter your key device id: " your_device_id < /dev/tty

keyid="$your_device_id"
# Update the system package list
sudo apt update
apt install screen -y

# Install Docker
if ! command -v docker &> /dev/null
then
    echo "Docker not detected, installing..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    if [ "$(lsb_release -is)" = "Debian" ]; then
        # Debian specific setup
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    elif [ "$(lsb_release -is)" = "Ubuntu" ]; then
        # Ubuntu specific setup
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    fi

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
else
    echo "Docker is already installed."
fi


# Download the PINGPONG program
wget -O PINGPONG https://pingpong-build.s3.ap-southeast-1.amazonaws.com/linux/latest/PINGPONG

if [ -f "./PINGPONG" ]; then
    chmod +x ./PINGPONG
    screen -dmS pingpong bash -c "./PINGPONG --key \"$keyid\""
else
    echo "Failed to download PINGPONG, please check your network connection or the URL."
fi

 echo "The node has been started, please use 'screen -r pingpong' to view the log or use script function 2"

}

function check_service_status() {
    screen -r pingpong
}

function reboot_pingpong() {
    read -p "Please enter your key device id: " your_device_id < /dev/tty
    keyid="$your_device_id"
    screen -dmS pingpong bash -c "./PINGPONG --key \"$keyid\""
}

# Function to display social media information
display_social_media() {
    echo -e "\033[0;34mYou can follow and communicate with me, and learn together through the following ways:\033[0m"
    echo -e "\033[0;32mTwitter:\033[0m \033[4;34mhttps://x.com/0x_onepiece\033[0m"
    echo -e "\033[0;32mMedium:\033[0m \033[4;34mhttps://medium.com/@0x_onepiece\033[0m"
    echo -e "\033[0;32mWebsite:\033[0m \033[4;34mhttp://noderunner.ninja\033[0m"
}

# Main menu
function main_menu() {
    clear
    display_social_media
    echo "Please select the operation to perform:"
    echo "1. Install node"
    echo "2. View node logs"
    echo "3. Restart pingpong"
    read -p "Enter your choice (1-3): " OPTION < /dev/tty

    case $OPTION in
    1) install_node ;;
    2) check_service_status ;;
    3) reboot_pingpong ;; 
    *) echo "Invalid option." ;;
    esac
}

# Display the main menu
main_menu
