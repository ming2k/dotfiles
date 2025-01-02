#!/bin/bash

# Check if swaylock is running (locked screen)
if pgrep -x "swaylock" > /dev/null; then
    # If locked, turn off the screen
    swaymsg "output * dpms off"
else
    # Do nothing if not locked
    exit 0
fi

