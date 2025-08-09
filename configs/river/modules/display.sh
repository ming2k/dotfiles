#!/bin/sh
# Display and monitor configuration

# Primary display configuration
wlr-randr --output eDP-1 --mode 3072x1920@120Hz --scale 2 --pos 0,0

# Secondary display configuration (commented)
# Modify the position to change the content of screen, same or extent.
# wlr-randr --output HDMI-A-1 --mode 1920x1080 --pos 0,0
# riverctl set-output-tags HDMI-A-1 9