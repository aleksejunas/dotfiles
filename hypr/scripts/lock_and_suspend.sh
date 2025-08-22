#!/bin/bash

LOG_FILE="$HOME/.config/hypr/suspend.log"

echo "$(date): Lock and suspend script initiated" >> "$LOG_FILE"

# Kill any existing swaylock processes
pkill swaylock 2>/dev/null || true
sleep 1

# Lock screen
echo "$(date): Locking screen" >> "$LOG_FILE"
swaylock --color 000000 --show-failed-attempts --ignore-empty-password --daemonize

# Wait for lock to establish
sleep 3

# Suspend
echo "$(date): Suspending system" >> "$LOG_FILE"
systemctl suspend
