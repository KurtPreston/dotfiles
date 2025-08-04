#!/bin/bash

# Git configuration setup script
# Prompts for user info on first install and stores it for future use

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
GIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$GIT_DIR")"
HOME_DIR="$HOME"
GIT_CONFIG_FILE="$HOME_DIR/.gitconfig"
GIT_USER_INFO_FILE="$DOTFILES_DIR/.git_user_info"

echo -e "${BLUE}Setting up Git configuration...${NC}"

# Function to prompt for user info
prompt_for_git_info() {
    echo -e "${YELLOW}Please provide your Git configuration:${NC}"
    
    # Get current git config if it exists
    CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
    CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
    
    # Prompt for name
    if [[ -n "$CURRENT_NAME" ]]; then
        echo -e "${GREEN}Current Git name: $CURRENT_NAME${NC}"
        read -p "Use current name? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            GIT_USER_NAME="$CURRENT_NAME"
        else
            read -p "Enter your name: " GIT_USER_NAME
        fi
    else
        read -p "Enter your name: " GIT_USER_NAME
    fi
    
    # Prompt for email
    if [[ -n "$CURRENT_EMAIL" ]]; then
        echo -e "${GREEN}Current Git email: $CURRENT_EMAIL${NC}"
        read -p "Use current email? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            GIT_USER_EMAIL="$CURRENT_EMAIL"
        else
            read -p "Enter your email: " GIT_USER_EMAIL
        fi
    else
        read -p "Enter your email: " GIT_USER_EMAIL
    fi
    
    # Validate input
    if [[ -z "$GIT_USER_NAME" || -z "$GIT_USER_EMAIL" ]]; then
        echo -e "${RED}Error: Name and email are required.${NC}"
        exit 1
    fi
    
    # Store the info for future use
    echo "GIT_USER_NAME=\"$GIT_USER_NAME\"" > "$GIT_USER_INFO_FILE"
    echo "GIT_USER_EMAIL=\"$GIT_USER_EMAIL\"" >> "$GIT_USER_INFO_FILE"
    
    echo -e "${GREEN}Git user info saved for future installations.${NC}"
}

# Function to load stored user info
load_git_user_info() {
    if [[ -f "$GIT_USER_INFO_FILE" ]]; then
        source "$GIT_USER_INFO_FILE"
        echo -e "${GREEN}Loaded stored Git user info:${NC}"
        echo -e "${BLUE}  Name: $GIT_USER_NAME${NC}"
        echo -e "${BLUE}  Email: $GIT_USER_EMAIL${NC}"
        return 0
    else
        return 1
    fi
}

# Function to create gitconfig from template
create_gitconfig() {
    local template_file="$GIT_DIR/gitconfig.template"
    local output_file="$GIT_CONFIG_FILE"
    
    if [[ ! -f "$template_file" ]]; then
        echo -e "${RED}Error: Git config template not found at $template_file${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Creating Git configuration...${NC}"
    
    # Create the gitconfig by replacing placeholders
    sed "s/GIT_USER_NAME/$GIT_USER_NAME/g; s/GIT_USER_EMAIL/$GIT_USER_EMAIL/g" "$template_file" > "$output_file"
    
    echo -e "${GREEN}Git configuration created at $output_file${NC}"
}

# Main logic
if load_git_user_info; then
    echo -e "${YELLOW}Found stored Git user info.${NC}"
    read -p "Use stored info? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        prompt_for_git_info
    fi
else
    echo -e "${YELLOW}No stored Git user info found.${NC}"
    prompt_for_git_info
fi

# Create the gitconfig
create_gitconfig

echo -e "${GREEN}Git configuration setup complete!${NC}" 