# ------------------------------------------------------------------------------
# Tag 1
# ------------------------------------------------------------------------------

riverctl rule-add -app-id "Alacritty" tags $((1 << 0))

# ------------------------------------------------------------------------------
# Tag 2
# ------------------------------------------------------------------------------

riverctl rule-add -app-id "org.mozilla.firefox" tags $((1 << 1))
riverctl rule-add -app-id "org.mozilla.firefox" -title "Picture-in-Picture" float

riverctl rule-add -app-id "google-chrome" tags $((1 << 1))
riverctl rule-add -app-id "org.chromium.Chromium" tags $((1 << 1))

# ------------------------------------------------------------------------------
# Tag 3
# ------------------------------------------------------------------------------

riverctl rule-add -app-id "com.libretro.RetroArch" 			float
riverctl rule-add -app-id "com.libretro.RetroArch" 			tags $((1 << 2))

riverctl rule-add -app-id "com.usebottles.bottles"      float
riverctl rule-add -app-id "com.usebottles.bottles" 			tags $((1 << 2))

riverctl rule-add -app-id "wineboot.exe"                float
riverctl rule-add -app-id "wineboot.exe" 			          tags $((1 << 2))

riverctl rule-add -app-id "org.telegram.desktop" 			  float
riverctl rule-add -app-id "org.telegram.desktop" 			  tags $((1 << 2))

riverctl rule-add -app-id "org.qbittorrent.qBittorrent"   float
riverctl rule-add -app-id "org.qbittorrent.qBittorrent" 	tags $((1 << 2))

riverctl rule-add -app-id "com.discordapp.Discord" 			  float
riverctl rule-add -app-id "com.discordapp.Discord" 			  tags $((1 << 2))

riverctl rule-add -app-id "org.prismlauncher.PrismLauncher" float
riverctl rule-add -app-id "org.prismlauncher.PrismLauncher" tags $((1 << 2))

riverctl rule-add -title "Minecraft*" 						float
riverctl rule-add -title "Minecraft*" 						tags $((1 << 2))

riverctl rule-add -app-id "org.qgis.qgis" -title "QGIS3" 	  float
riverctl rule-add -app-id "org.qgis.qgis" 					        tags $((1 << 2))

riverctl rule-add -app-id "com.heroicgameslauncher.hgl"     tags $((1 << 2))
riverctl rule-add -app-id "factorio"                        tags $((1 << 2))

riverctl rule-add -app-id "java" -title "Dbeaver" 			    float
riverctl rule-add -app-id "Dbeaver" 						            tags $((1 << 2))

riverctl rule-add -app-id "gimp" 						                tags $((1 << 2))



# ------------------------------------------------------------------------------
# Tag 4
# Misc
# ------------------------------------------------------------------------------

riverctl rule-add -app-id "qemu"          float
riverctl rule-add -app-id "qemu" 					tags $((1 << 3))

riverctl rule-add -app-id "com.obsproject.Studio" 	        float
riverctl rule-add -app-id "com.obsproject.Studio" 					tags $((1 << 2))

# ------------------------------------------------------------------------------
# Utils
# ------------------------------------------------------------------------------

riverctl rule-add -app-id "emacs" float

riverctl rule-add -app-id "xdg-desktop-portal-gtk"          float

riverctl rule-add -app-id "mpv" float
riverctl rule-add -app-id "kitty" float
riverctl rule-add -app-id "imv" float
riverctl rule-add -app-id "swayimg" float

riverctl rule-add -app-id "org.pwmt.zathura"                float

riverctl rule-add -app-id "Pinentry-gtk"                    float
riverctl rule-add -app-id "org.gnome.seahorse.Application"  float

riverctl rule-add -app-id "org.fcitx.fcitx5-config-qt" float

riverctl rule-add -app-id "org.example.pomodoro_timer" float
riverctl rule-add -app-id "songrec" float
riverctl rule-add -app-id "localsend" float

riverctl rule-add -app-id "com.github.tchx84.Flatseal" float

riverctl rule-add -app-id "praise-of-life" float


