#!/bin/bash

# Function to install plugins
install_plugins() {
    echo "Installing plugins..."
    local ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
    
    git clone https://github.com/zsh-users/zsh-autosuggestions --depth=1 $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git --depth=1 $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git --depth=1 $ZSH_CUSTOM/plugins/you-should-use
    git clone https://github.com/romkatv/powerlevel10k.git --depth=1 $ZSH_CUSTOM/themes/powerlevel10k
}

# Call the function to install plugins
install_plugins
