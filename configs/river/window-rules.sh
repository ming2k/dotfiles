riverctl rule-add -app-id "xdg-desktop-portal-gtk" float
riverctl rule-add -app-id "org.pwmt.zathura" float

riverctl rule-add -app-id "org.fcitx.fcitx5-config-qt" float

riverctl rule-add -app-id "org.example.pomodoro_timer" float
riverctl rule-add -app-id "songrec" float
riverctl rule-add -app-id "localsend" float

riverctl rule-add -app-id "org.mozilla.firefox" -title "Picture-in-Picture" float

# Tag 2
riverctl rule-add -app-id "org.mozilla.firefox" tags $((1 << 1))
riverctl rule-add -app-id "google-chrome" tags $((1 << 1))

# Tag 3
riverctl rule-add -app-id "com.libretro.RetroArch" 			float
riverctl rule-add -app-id "com.libretro.RetroArch" 			tags $((1 << 2))
riverctl rule-add -app-id "org.telegram.desktop" 			float
riverctl rule-add -app-id "org.telegram.desktop" 			tags $((1 << 2))
riverctl rule-add -app-id "org.qbittorrent.qBittorrent" 	float
riverctl rule-add -app-id "org.qbittorrent.qBittorrent" 	tags $((1 << 2))
riverctl rule-add -app-id "com.discordapp.Discord" 			float
riverctl rule-add -app-id "com.discordapp.Discord" 			tags $((1 << 2))
riverctl rule-add -app-id "org.prismlauncher.PrismLauncher" float
riverctl rule-add -app-id "org.prismlauncher.PrismLauncher" tags $((1 << 2))
riverctl rule-add -title "Minecraft*" 			float
riverctl rule-add -title "Minecraft*" 			tags $((1 << 2))

# Utils
riverctl rule-add -app-id "mpv" float
riverctl rule-add -app-id "imv" float
riverctl rule-add -app-id "swayimg" float
