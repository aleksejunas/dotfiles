#!/bin/bash

# Script to launch different rofi modes

# Define available modes
modes="drun\nrun\nwindow\nfilebrowser\ncalc\nemoji\nkeys\nbluetooth\nnetwork\nscreenshot\npowermenu\nasroot"

# Show menu and get selection
selected=$(echo -e "$modes" | rofi -dmenu -p "Select Rofi Mode")

# Launch the selected mode
case "$selected" in
    "drun")
        rofi -show drun
        ;;
    "run")
        rofi -show run
        ;;
    "window")
        rofi -show window
        ;;
    "filebrowser")
        rofi -show filebrowser
        ;;
    "calc")
        rofi -show calc
        ;;
    "emoji")
        rofi -show emoji
        ;;
    "keys")
        rofi -show keys
        ;;
    "bluetooth")
        ~/.config/rofi/scripts/rofi_bluetooth
        ;;
    "network")
        ~/.config/rofi/scripts/rofi_network
        ;;
    "screenshot")
        ~/.config/rofi/scripts/rofi_screenshot
        ;;
    "powermenu")
        ~/.config/rofi/scripts/rofi_powermenu
        ;;
    "asroot")
        ~/.config/rofi/scripts/rofi_asroot
        ;;
    *)
        echo "No selection made"
        ;;
esac
