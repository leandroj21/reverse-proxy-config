#!/usr/bin/env bash

# Swap memory
echo "Creating swap memory..."
sudo dd if=/dev/zero of=/swapfile count=2048 bs=1MiB
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Get dependencies
sudo apt update && sudo apt -y install zip unzip nmap apache2 certbot tree

# Install sdkman and java
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 17.0.9-tem

# Init apache server
sudo service apache2 start

# Cloning the repo
cd ~/
git clone https://github.com/leandroj21/reverse-proxy-config

# Moving config files
sudo cp ~/reverse-proxy-config/secure-rev-proxy.conf /etc/apache2/sites-available/

# Prepare the apps execution
cd ~/reverse-proxy-config/apps

# Create fatjar
chmod +x gradlew
./gradlew shadowjar

# Execute the Javalin apps in the ports 7070 and 7080
java -jar ~/reverse-proxy-config/apps/build/libs/app.jar > ~/reverse-proxy-config/apps/build/libs/output.txt 2> ~/reverse-proxy-config/apps/build/libs/errors.txt &
