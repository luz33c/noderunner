#!/bin/bash

# Prompt the user to enter a username and password
echo "Please enter a username for remote desktop access:"
read USER
echo "Please enter a password for remote desktop access:"
read -s PASSWORD  # The -s option hides the input for privacy

# Update the package list
sudo apt update

# Install GNOME Desktop
sudo apt install -y ubuntu-desktop

# Install the remote desktop server (xrdp)
sudo apt install -y xrdp

# Add the user $user with the password $password
sudo useradd -m -s /bin/bash $USER
echo "$USER:$PASSWORD" | sudo chpasswd

# Add the user $user to the sudo group for administrative rights
sudo usermod -aG sudo $USER

# Configure xrdp to use the GNOME desktop
echo "gnome-session" > ~/.xsession

# Restart the xrdp service
sudo systemctl restart xrdp

# Enable xrdp at startup
sudo systemctl enable xrdp

# Install the necessary dependencies for Google Chrome
sudo apt install -y wget gnupg

# Add the Google repository key
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# Add the Google Chrome repository
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Update the package list again
sudo apt update

# Install Google Chrome
sudo apt install -y google-chrome-stable

echo "Installation complete. GNOME Desktop, xrdp, and Google Chrome have been installed. You can now connect via Remote Desktop with the user $USER."
