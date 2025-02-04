#!/bin/bash

sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen -y


sudo apt-get install zsh -y

sudo apt update && sudo apt install software-properties-common -y

sudo add-apt-repository ppa:ondrej/php
sudo apt update


# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Download and install Node.js:
nvm install 22

# Verify the Node.js version:
node -v # Should print "v22.13.1".
nvm current # Should print "v22.13.1".

# Verify npm version:
npm -v # Should print "10.9.2".
