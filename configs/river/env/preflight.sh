# Config systemd and dbus env variables
# It's necessary for xdg-desktop-portal, without it, xdg-desktop-portal won't work
dbus-update-activation-environment --systemd \
    XDG_CURRENT_DESKTOP \
    WAYLAND_DISPLAY


