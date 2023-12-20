#!/bin/bash

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

clear

# Welcome message
echo "$(tput setaf 6)Welcome to FeelProud's Install Script!$(tput sgr0)"
echo
echo "$(tput setaf 166)ATTENTION: Run a full system update and Reboot first!! (Highly Recommended) $(tput sgr0)"
echo
read -p "$(tput setaf 6)Would you like to proceed? (y/n): $(tput sgr0)" proceed

if [ "$proceed" != "y" ]; then
    echo "Installation aborted."
    exit 1
fi

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Function to colorize prompts
colorize_prompt() {
    local color="$1"
    local message="$2"
    echo -n "${color}${message}$(tput sgr0)"
}

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S).log"

# Set directory folder
script_directory=install-scripts

# Function to execute a script if it exists and make it executable
execute_script() {
    local script="$1"
    local script_path="$script_directory/$script"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if [ -x "$script_path" ]; then
            "$script_path"
        else
            echo "Failed to make script '$script' executable."
        fi
    else
        echo "Script '$script' not found in '$script_directory'."
    fi
}

# Ensuring all in the scripts folder are made executable
chmod +x install-scripts/*

# Install paru
execute_script "paru.sh"

# Install hyprland packages
execute_script "00-hypr-pkgs.sh"

# Install pipewire and pipewire-audio
execute_script "pipewire.sh"

# Install nvidia drivers
execute_script "nvidia.sh"

# Install hyprland
execute_script "hyprland.sh"

# Install bluetooth
execute_script "bluetooth.sh"

# Install thunar
execute_script "thunar.sh"

# Install sddm
execute_script "sddm.sh"

# Install xdph
execute_script "xdph.sh"

# Install zsh
execute_script "zsh.sh"

# Install dotfiles
# execute_script "dotfiles.sh"

clear

printf "\n${OK} Yey! Installation Completed.\n"
printf "\n"
printf "\n${NOTE} System rebooting!\n"
sleep 5
systemctl reboot

