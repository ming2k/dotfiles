# River shorcuts
riverctl map normal Super W close
riverctl map normal Super+Control Q exit
riverctl map normal Super+Control L spawn "systemctl suspend"

# ------------------------------------------------------------
# Tags
# ------------------------------------------------------------
# Super+1 to Super+9 to focus tags 1 to 9
for i in {1..9}
do
    riverctl map normal Super $i set-focused-tags $((1 << ($i - 1)))
done

# Super+Shift+1 to Super+Shift+9 to assign the focused view to tags 1 to 9
for i in {1..9}
do
    riverctl map normal Super+Shift $i set-view-tags $((1 << ($i - 1)))
done

# Super+Control+1 to Super+Control+9 to toggle visibility of tags 1 to 9
for i in {1..9}
do
    riverctl map normal Super+Control $i toggle-focused-tags $((1 << ($i - 1)))
done

riverctl map normal Super+Shift S spawn "riverctl set-view-tags $((2**32 - 1))"

# ------------------------------------------------------------
# Views
# ------------------------------------------------------------

# Focus the next/previous view in the layout stack
riverctl map normal Super       Tab         focus-view next
riverctl map normal Super+Shift Tab         focus-view previous
riverctl map normal Super       period      focus-view next
riverctl map normal Super       comma       focus-view previous

# Swap the focused view with the next/previous
riverctl map normal Super+Shift comma   swap previous
riverctl map normal Super+Shift period  swap next

riverctl map-pointer normal Super BTN_LEFT move-view
riverctl map-pointer normal Super BTN_RIGHT resize-view

# ------------------------------------------------------------
# Layout Command
# ------------------------------------------------------------

riverctl map normal Super+Shift   P    	swap previous
riverctl map normal Super+Shift   N  	swap next

riverctl map normal Super Equal send-layout-cmd rivercarro "main-ratio +0.05"
riverctl map normal Super Minus send-layout-cmd rivercarro "main-ratio -0.05"

riverctl map normal Super+Shift Equal send-layout-cmd rivercarro "main-count +1"
riverctl map normal Super+Shift Minus send-layout-cmd rivercarro "main-count -1"

# Mod+{Up,Right,Down,Left} to change layout orientation
riverctl map normal Super Up    send-layout-cmd rivercarro "main-location top"
riverctl map normal Super Right send-layout-cmd rivercarro "main-location right"
riverctl map normal Super Down  send-layout-cmd rivercarro "main-location bottom"
riverctl map normal Super Left  send-layout-cmd rivercarro "main-location left"

riverctl map normal Super           F   toggle-float
riverctl map normal Super+Shift     F   toggle-fullscreen
riverctl map normal Super           M   send-layout-cmd rivercarro "main-location-cycle left,monocle"

# ------------------------------------------------------------
# Applications
# ------------------------------------------------------------

riverctl map normal Super A         spawn "wofi --show drun"
#riverctl map normal Super Return    spawn "foot"
riverctl map normal Super Return    spawn "alacritty"

# Region screenshot to clipboard (PrintScreen)
riverctl map normal None Print spawn 'grim -g "$(slurp)" - | wl-copy'

# Region screenshot to file (Shift + PrintScreen)
riverctl map normal Shift Print spawn 'grim -g "$(slurp)" ~/Pictures/screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png'

# OCR shortcuts
riverctl map normal Super O spawn '$HOME/.config/river/scripts/ocr.sh -s -c'
riverctl map normal Super+Shift O spawn '$HOME/.config/river/scripts/ocr.sh -s -c -p'

# ------------------------------------------------------------
# Multiple Display
# ------------------------------------------------------------
riverctl map normal Super+Control bracketleft focus-output next
riverctl map normal Super+Control bracketright focus-output previous

riverctl map normal Super+Shift bracketleft send-to-output next
riverctl map normal Super+Shift bracketright send-to-output previous


