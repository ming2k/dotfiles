#!/bin/sh
# Input device configuration

# Set keyboard repeat rate
riverctl set-repeat 60 300

# Set current laptop's touchpad natural scroll
# Via `riverctl list-inputs`
riverctl input 'pointer-1267-12693-ELAN0676:00_04F3:3195_Touchpad' natural-scroll enabled
