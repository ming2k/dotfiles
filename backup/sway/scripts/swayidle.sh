#!/bin/bash

    # Check whether locked, if it does, light off screen, or do nothing
swayidle -w \
    timeout 3 './swayidle.d/check_lock_and_dpms.sh' \
        resume 'swaymsg "output * dpms on"' \
    timeout 600 './swayidle.d/check_lock_and_lock.sh' \
    timeout 900 'systemctl suspend' \
    lock 'swaylock -f' \
    before-sleep 'swaylock -f' 

