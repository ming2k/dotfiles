riverctl spawn "pkill swaybg; swaybg -i ~/.config/river/assets/wallpapers/the-school-of-athens.jpg -m fill"
riverctl spawn "pkill waybar; waybar -c ~/.config/waybar/river/config -s ~/.config/waybar/river/style.css"
riverctl spawn "pkill mako; mako"  
riverctl spawn "pkill fcitx5; fcitx5 -r -d"


start_idle() {
    swayidle -w \
        timeout 900 'exec swaylock -f' \
        timeout 910 'wlr-randr --output eDP-1 --off' \
        resume 'wlr-randr --output eDP-1 --on' \
        before-sleep 'exec swaylock -f'
}

riverctl spawn "$(declare -f start_idle); start_idle"
