#!/bin/bash

# Check if swaylock is running (locked screen)
if pgrep -x "swaylock" > /dev/null; then
    # Do nothing if locked
    exit 0
else
    # If not locked, lock it
    swaylock -f
fi

