#!/bin/bash

# Screenshot script using rofi

options="Screen now\nScreen in 5s\nScreen in 10s\nActive window\nSelect area"

selected=$(echo -e "$options" | rofi -dmenu -p "Screenshot")

case "$selected" in
    "Screen now")
        grimblast save output
        ;;
    "Screen in 5s")
        sleep 5 && grimblast save output
        ;;
    "Screen in 10s")
        sleep 10 && grimblast save output
        ;;
    "Active window")
        grimblast save active
        ;;
    "Select area")
        grimblast save area
        ;;
    *)
        echo "No selection made"
        ;;
esac
