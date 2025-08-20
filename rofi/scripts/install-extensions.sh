#!/bin/bash

# Installation script for Rofi extensions

echo "Installing Rofi extensions..."

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "Error: yay is not installed. Please install it first."
    exit 1
fi

# Check for pacman
if ! command -v pacman &> /dev/null; then
    echo "Error: pacman is not found. This script is for Arch-based systems."
    exit 1
fi

# Install from official repositories
echo "Installing packages from official repositories..."
sudo pacman -S --needed rofi rofi-calc

# Install from AUR
echo "Installing packages from AUR..."
yay -S --needed rofi-emoji rofi-greenclip rofi-bluetooth rofi-wifi-menu rofi-pass rofi-screenshot rofi-tmux

echo "Setting up configuration..."

# Make sure scripts directory exists
mkdir -p ~/.config/rofi/scripts

# Make sure all scripts are executable
find ~/.config/rofi/scripts -type f -name "rofi_*" -exec chmod +x {} \;
chmod +x ~/.config/rofi/scripts/rofi-modes.sh

echo "Installation complete!"
echo "Use 'Super+Shift+D' to access the Rofi mode selector or use direct keyboard shortcuts:"
echo "- Super+E: Emoji picker"
echo "- Super+C: Calculator"
echo "- Super+K: Keybindings viewer"
echo "- Super+Tab: Window selector"
echo "- Plus your existing Rofi shortcuts"

echo "Don't forget to add the keybindings by importing keybinds-rofi.conf in your Hyprland configuration."
