#!/bin/bash

sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen -y


sudo apt-get install zsh -y

sudo apt update && sudo apt install software-properties-common -y


sudo add-apt-repository ppa:ondrej/php
sudo apt update


# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
