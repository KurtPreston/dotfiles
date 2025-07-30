#!/bin/bash

# Simple dotfiles installation script
# This script creates symlinks for the appropriate shell configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing dotfiles...${NC}"

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ -L "$target" ]]; then
        echo -e "${YELLOW}Removing existing symlink: $target${NC}"
        rm "$target"
    elif [[ -f "$target" ]]; then
        echo -e "${YELLOW}Backing up existing file: $target${NC}"
        mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    echo -e "${GREEN}Creating symlink: $target -> $source${NC}"
    ln -s "$source" "$target"
}

# Detect the current shell
CURRENT_SHELL=$(basename "$SHELL")

echo -e "${GREEN}Detected shell: $CURRENT_SHELL${NC}"

# Create symlink for the entire dotfiles directory
echo -e "${GREEN}Installing dotfiles...${NC}"
if [[ -L "$HOME_DIR/.dotfiles" ]]; then
    echo -e "${YELLOW}Removing existing symlink: $HOME_DIR/.dotfiles${NC}"
    rm "$HOME_DIR/.dotfiles"
elif [[ -d "$HOME_DIR/.dotfiles" ]]; then
    echo -e "${YELLOW}Backing up existing directory: $HOME_DIR/.dotfiles${NC}"
    mv "$HOME_DIR/.dotfiles" "$HOME_DIR/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
fi

echo -e "${GREEN}Creating symlink: $HOME_DIR/.dotfiles -> $DOTFILES_DIR${NC}"
ln -s "$DOTFILES_DIR" "$HOME_DIR/.dotfiles"

# Install based on detected shell
case "$CURRENT_SHELL" in
    "bash")
        echo -e "${GREEN}Installing bash configuration...${NC}"
        create_symlink "$DOTFILES_DIR/bash/bashrc" "$HOME_DIR/.bashrc"
        create_symlink "$DOTFILES_DIR/bash/bash_profile" "$HOME_DIR/.bash_profile"
        ;;
    "zsh")
        echo -e "${GREEN}Installing zsh configuration...${NC}"
        create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME_DIR/.zshrc"
        ;;
    "fish")
        echo -e "${GREEN}Installing fish configuration...${NC}"
        mkdir -p "$HOME_DIR/.config/fish"
        create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME_DIR/.config/fish/config.fish"
        ;;
    *)
        echo -e "${RED}Unsupported shell: $CURRENT_SHELL${NC}"
        echo -e "${YELLOW}Please manually install the configuration for your shell.${NC}"
        exit 1
        ;;
esac

# Setup Git configuration
echo -e "${GREEN}Setting up Git configuration...${NC}"
"$DOTFILES_DIR/git/setup_gitconfig.sh"

echo -e "${GREEN}Installation complete!${NC}"
echo -e "${YELLOW}Please restart your shell or run 'source ~/.${CURRENT_SHELL}rc' to apply changes.${NC}" 