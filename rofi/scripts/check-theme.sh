#!/bin/bash

# Check for theme errors and fix them

echo "Checking Rofi theme configuration..."

# Test if rofi can load the theme
if ! rofi -dump-theme 2>/dev/null; then
    echo "Theme error detected. Installing custom theme with all required variables."
    
    # Create themes directory if it doesn't exist
    mkdir -p ~/.config/rofi/themes
    
    # Create a custom theme file with all required variables
    cat > ~/.config/rofi/themes/custom-theme.rasi << 'EOL'
/**
 * Custom theme for Rofi with all required variables
 */

* {
    /* Base colors */
    background-color:               #282c34;
    background:                     #282c34;
    foreground:                     #d8dee9;
    border-color:                   #3b4252;
    separatorcolor:                 #3b4252;
    scrollbar-handle:               #3b4252;

    /* Normal colors */
    normal-background:              @background;
    normal-foreground:              @foreground;
    alternate-normal-background:    #2e3440;
    alternate-normal-foreground:    @foreground;
    selected-normal-background:     #81a1c1;
    selected-normal-foreground:     #ffffff;

    /* Active colors */
    active-background:              #3b4252;
    active-foreground:              @foreground;
    alternate-active-background:    #3b4252;
    alternate-active-foreground:    @foreground;
    selected-active-background:     #81a1c1;
    selected-active-foreground:     #ffffff;

    /* Urgent colors */
    urgent-background:              #bf616a;
    urgent-foreground:              @foreground;
    alternate-urgent-background:    #bf616a;
    alternate-urgent-foreground:    @foreground;
    selected-urgent-background:     #d08770;
    selected-urgent-foreground:     #ffffff;

    /* Text properties */
    text-color:                     @foreground;
    cursor:                         @foreground;
    spacing:                        2;
    font:                           "SauceCodePro Nerd Font Medium 12";
}

window {
    background-color: @background;
    border:           1;
    padding:          5;
}

mainbox {
    border:  0;
    padding: 0;
}

message {
    border:       1px dash 0px 0px;
    border-color: @separatorcolor;
    padding:      1px;
}

textbox {
    text-color: @foreground;
}

listview {
    fixed-height: 0;
    border:       2px solid 0px 0px;
    border-color: @separatorcolor;
    spacing:      2px;
    scrollbar:    true;
    padding:      2px 0px 0px;
}

element {
    border:  0;
    padding: 1px;
}

element normal.normal {
    background-color: @normal-background;
    text-color:       @normal-foreground;
}

element normal.urgent {
    background-color: @urgent-background;
    text-color:       @urgent-foreground;
}

element normal.active {
    background-color: @active-background;
    text-color:       @active-foreground;
}

element selected.normal {
    background-color: @selected-normal-background;
    text-color:       @selected-normal-foreground;
}

element selected.urgent {
    background-color: @selected-urgent-background;
    text-color:       @selected-urgent-foreground;
}

element selected.active {
    background-color: @selected-active-background;
    text-color:       @selected-active-foreground;
}

element alternate.normal {
    background-color: @alternate-normal-background;
    text-color:       @alternate-normal-foreground;
}

element alternate.urgent {
    background-color: @alternate-urgent-background;
    text-color:       @alternate-urgent-foreground;
}

element alternate.active {
    background-color: @alternate-active-background;
    text-color:       @alternate-active-foreground;
}

scrollbar {
    width:        4px;
    border:       0;
    handle-color: @scrollbar-handle;
    handle-width: 8px;
    padding:      0;
}

sidebar {
    border:       2px dash 0px 0px;
    border-color: @separatorcolor;
}

button {
    spacing:    0;
    text-color: @normal-foreground;
}

button selected {
    background-color: @selected-normal-background;
    text-color:       @selected-normal-foreground;
}

inputbar {
    spacing:    0;
    text-color: @normal-foreground;
    padding:    1px;
    children:   [ prompt,textbox-prompt-colon,entry,case-indicator ];
}

case-indicator {
    spacing:    0;
    text-color: @normal-foreground;
}

entry {
    spacing:    0;
    text-color: @normal-foreground;
}

prompt {
    spacing:    0;
    text-color: @normal-foreground;
}

textbox-prompt-colon {
    expand:     false;
    str:        ":";
    margin:     0px 0.3em 0em 0em;
    text-color: @normal-foreground;
}
EOL
    
    # Update the configuration file to use our theme
    sed -i 's|@theme.*|@theme "~/.config/rofi/themes/custom-theme.rasi"|' ~/.config/rofi/config.rasi
    
    echo "Custom theme installed successfully."
    echo "Rofi configuration has been updated to use the new theme."
else
    echo "Theme configuration appears to be working correctly."
fi
