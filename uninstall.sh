#!/bin/bash

# Dotfiles uninstall script
# This script removes all symlinks in $HOME that point to the dotfiles project directory

set -e

# Parse command line arguments
DRY_RUN=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --dry-run    Show what would be removed without actually removing anything"
            echo "  -h, --help   Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Uninstalling dotfiles...${NC}"

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# Function to check if a symlink points to the dotfiles directory
is_dotfiles_symlink() {
    local link_path="$1"
    local target_path
    
    if [[ -L "$link_path" ]]; then
        target_path=$(readlink "$link_path")
        # Check if the target is within the dotfiles directory
        if [[ "$target_path" == "$DOTFILES_DIR"/* ]] || [[ "$target_path" == "$DOTFILES_DIR" ]]; then
            return 0
        fi
    fi
    return 1
}

# Function to remove a symlink
remove_symlink() {
    local link_path="$1"
    local target_path=$(readlink "$link_path")
    
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${BLUE}[DRY RUN] Would remove symlink: $link_path -> $target_path${NC}"
    else
        echo -e "${YELLOW}Removing symlink: $link_path -> $target_path${NC}"
        rm "$link_path"
    fi
}

# Find and remove all symlinks in $HOME that point to the dotfiles directory
if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "${BLUE}[DRY RUN] Scanning for symlinks in $HOME_DIR that point to dotfiles...${NC}"
else
    echo -e "${BLUE}Scanning for symlinks in $HOME_DIR that point to dotfiles...${NC}"
fi

found_symlinks=false

# Find all symlinks in $HOME (including hidden files)
while IFS= read -r -d '' link_path; do
    if is_dotfiles_symlink "$link_path"; then
        remove_symlink "$link_path"
        found_symlinks=true
    fi
done < <(find "$HOME_DIR" -maxdepth 1 -type l -print0 2>/dev/null)

# Also check for symlinks in common subdirectories
for subdir in ".config" ".local" ".cache"; do
    if [[ -d "$HOME_DIR/$subdir" ]]; then
        while IFS= read -r -d '' link_path; do
            if is_dotfiles_symlink "$link_path"; then
                remove_symlink "$link_path"
                found_symlinks=true
            fi
        done < <(find "$HOME_DIR/$subdir" -type l -print0 2>/dev/null)
    fi
done

if [[ "$found_symlinks" == "false" ]]; then
    echo -e "${BLUE}No symlinks pointing to dotfiles were found in $HOME_DIR${NC}"
else
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${GREEN}[DRY RUN] Would complete uninstallation!${NC}"
        echo -e "${YELLOW}[DRY RUN] Note: You may need to restart your shell or manually restore your original configuration files.${NC}"
    else
        echo -e "${GREEN}Uninstallation complete!${NC}"
        echo -e "${YELLOW}Note: You may need to restart your shell or manually restore your original configuration files.${NC}"
    fi
fi 