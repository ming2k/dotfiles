#!/bin/bash

# Function to check lock and turn off screen
check_lock_and_dpms() {
    # Check if swaylock is running (locked screen)
    if pgrep -x "swaylock" > /dev/null; then
        # If locked, turn off the screen
        swaymsg "output * dpms off"
    else
        # Do nothing if not locked
        exit 0
    fi
}

# Function to check lock and lock screen
check_lock_and_lock() {
    # Check if swaylock is running (locked screen)
    if pgrep -x "swaylock" > /dev/null; then
        # Do nothing if locked
        exit 0
    else
        # If not locked, lock it
        swaylock -f
    fi
}

# Main swayidle configuration
swayidle -w \
    timeout 3 'check_lock_and_dpms' \
        resume 'swaymsg "output * dpms on"' \
    timeout 600 'check_lock_and_lock' \
    timeout 900 'systemctl suspend' \
    lock 'swaylock -f' \
    before-sleep 'swaylock -f'
