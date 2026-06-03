#!/bin/bash

# Dependency check script
# Checks for optional tools used by these dotfiles and prints
# per-OS install instructions for any that are missing.

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Tools to check. Each entry maps a command name to a short description.
DEPS=(
    "git:Version control"
    "fzf:Fuzzy finder (history search, completions)"
    "rg:ripgrep, fast recursive search"
    "delta:Syntax-highlighting pager for git diffs"
    "jq:JSON processor (used by node version auto-switch)"
)

# Detect the operating system / package manager hint.
detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if [[ -f /etc/os-release ]]; then
                # shellcheck disable=SC1091
                . /etc/os-release
                case "$ID $ID_LIKE" in
                    *debian*|*ubuntu*)
                        echo "debian"
                        ;;
                    *fedora*|*rhel*|*centos*)
                        echo "fedora"
                        ;;
                    *arch*)
                        echo "arch"
                        ;;
                    *suse*)
                        echo "suse"
                        ;;
                    *)
                        echo "linux"
                        ;;
                esac
            else
                echo "linux"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Print the install command for a given tool on a given OS.
install_hint() {
    local tool="$1"
    local os="$2"

    # ripgrep's binary is "rg" but the package is "ripgrep".
    local pkg="$tool"
    if [[ "$tool" == "rg" ]]; then
        pkg="ripgrep"
    fi
    # git-delta is packaged under various names.
    if [[ "$tool" == "delta" ]]; then
        case "$os" in
            macos) pkg="git-delta" ;;
            debian) pkg="git-delta" ;;
            fedora) pkg="git-delta" ;;
            arch) pkg="git-delta" ;;
            suse) pkg="git-delta" ;;
        esac
    fi

    case "$os" in
        macos)
            echo "brew install $pkg"
            ;;
        debian)
            if [[ "$tool" == "delta" ]]; then
                # 'git-delta' only exists in apt on Ubuntu 23.04+/Debian 13+.
                # The 'delta' apt package is an unrelated tool, so don't suggest it.
                if apt-cache show git-delta >/dev/null 2>&1; then
                    echo "sudo apt install git-delta"
                else
                    echo "download the .deb from https://github.com/dandavison/delta/releases and run 'sudo dpkg -i <file>.deb' (or 'cargo install git-delta')"
                fi
            else
                echo "sudo apt install $pkg"
            fi
            ;;
        fedora)
            echo "sudo dnf install $pkg"
            ;;
        arch)
            echo "sudo pacman -S $pkg"
            ;;
        suse)
            echo "sudo zypper install $pkg"
            ;;
        *)
            echo "install '$pkg' via your system package manager"
            ;;
    esac
}

main() {
    local os
    os="$(detect_os)"

    echo -e "${BLUE}Checking optional dependencies...${NC}"
    echo -e "${BLUE}Detected OS: $os${NC}"
    echo

    local missing=()

    for entry in "${DEPS[@]}"; do
        local cmd="${entry%%:*}"
        local desc="${entry#*:}"

        if command -v "$cmd" >/dev/null 2>&1; then
            echo -e "${GREEN}  [ok]${NC} $cmd - $desc"
        else
            echo -e "${RED}  [missing]${NC} $cmd - $desc"
            missing+=("$cmd")
        fi
    done

    echo

    if [[ ${#missing[@]} -eq 0 ]]; then
        echo -e "${GREEN}All optional dependencies are installed!${NC}"
        return 0
    fi

    echo -e "${YELLOW}Missing dependencies and how to install them:${NC}"
    for cmd in "${missing[@]}"; do
        echo -e "${YELLOW}  $cmd:${NC} $(install_hint "$cmd" "$os")"
    done

    return 0
}

main "$@"
