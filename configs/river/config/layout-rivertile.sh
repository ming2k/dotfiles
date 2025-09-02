# Rivertile layout manager configuration

# Set default layout manager (rivertile only)
riverctl default-layout rivertile
riverctl output-layout rivertile

# Start rivertile layout manager
rivertile -view-padding 0 -outer-padding 0 -main-location left -main-count 1 -main-ratio 0.6 &

# Rivertile-specific keybindings
riverctl map normal Super+Alt Equal send-layout-cmd rivertile "main-ratio +0.05"
riverctl map normal Super+Alt Minus send-layout-cmd rivertile "main-ratio -0.05"

riverctl map normal Super+Alt+Shift Equal send-layout-cmd rivertile "main-count +1"
riverctl map normal Super+Alt+Shift Minus send-layout-cmd rivertile "main-count -1"

riverctl map normal Super+Alt Up    send-layout-cmd rivertile "main-location top"
riverctl map normal Super+Alt Right send-layout-cmd rivertile "main-location right"
riverctl map normal Super+Alt Down  send-layout-cmd rivertile "main-location bottom"
riverctl map normal Super+Alt Left  send-layout-cmd rivertile "main-location left"
