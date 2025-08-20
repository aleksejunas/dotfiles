#!/bin/bash

# Check if the keybinds-rofi.conf file exists
if [ ! -f ~/.config/hypr/keybinds-rofi.conf ]; then
    echo "Creating keybinds-rofi.conf in ~/.config/hypr/"
    mkdir -p ~/.config/hypr/
    cat > ~/.config/hypr/keybinds-rofi.conf << 'EOL'
# Rofi Extensions Configuration

# Core rofi modes
bind = SUPER, E, exec, rofi -show emoji
bind = SUPER, C, exec, rofi -show calc
bind = SUPER, K, exec, rofi -show keys
bind = SUPER, Tab, exec, rofi -show window

# Shortcut to access rofi mode selector
bind = SUPER_SHIFT, D, exec, ~/.config/rofi/scripts/rofi-modes.sh

# Keep existing rofi bindings
# -- Rofi --
bind = SUPER, D, exec, ~/.config/rofi/scripts/launcher_t6 &
bind = ALT, F1, exec, $rofi_launcher
bind = ALT, F2, exec, $rofi_runner
bind = SUPER, R, exec, $rofi_asroot
bind = SUPER, M, exec, $rofi_music
bind = SUPER, N, exec, $rofi_network
bind = SUPER, B, exec, $rofi_bluetooth
bind = SUPER, X, exec, $rofi_powermenu
bind = SUPER, A, exec, $rofi_screenshot
EOL
    echo "File created successfully."
else
    echo "keybinds-rofi.conf already exists."
fi

# Check if the line is already included in hyprland.conf
if ! grep -q "source.*keybinds-rofi.conf" ~/.config/hypr/hyprland.conf; then
    echo "Adding source line to hyprland.conf"
    echo -e "\n# Import rofi keybindings configuration\nsource = ~/.config/hypr/keybinds-rofi.conf" >> ~/.config/hypr/hyprland.conf
    echo "Configuration updated successfully."
else
    echo "Source line already exists in hyprland.conf"
fi

echo "Setup complete! Please restart Hyprland to apply changes."
