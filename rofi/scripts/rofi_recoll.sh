#!/usr/bin/env bash
query=$(rofi -dmenu -p "Recoll: " - lines 10) || exit
recoll -t -q "$query" | cut -f2 | rofi -dmenu -p "Result:" xargs xdg-open
