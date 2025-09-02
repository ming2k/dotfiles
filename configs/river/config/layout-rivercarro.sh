# Rivercarro layout manager configuration

# Set default layout manager (rivertile only)
riverctl default-layout rivercarro
riverctl output-layout rivercarror

# Start rivercarro layout manager
rivercarro -inner-gaps 0 -outer-gaps 0 -per-tag &

# Rivercarro-specific keybindings
riverctl map normal Super Equal send-layout-cmd rivercarro "main-ratio +0.05"
riverctl map normal Super Minus send-layout-cmd rivercarro "main-ratio -0.05"

riverctl map normal Super+Shift Equal send-layout-cmd rivercarro "main-count +1"
riverctl map normal Super+Shift Minus send-layout-cmd rivercarro "main-count -1"

# Mod+{Up,Right,Down,Left} to change layout orientation
riverctl map normal Super Up    send-layout-cmd rivercarro "main-location top"
riverctl map normal Super Right send-layout-cmd rivercarro "main-location right"
riverctl map normal Super Down  send-layout-cmd rivercarro "main-location bottom"
riverctl map normal Super Left  send-layout-cmd rivercarro "main-location left"

riverctl map normal Super M send-layout-cmd rivercarro "main-location-cycle left,monocle"
