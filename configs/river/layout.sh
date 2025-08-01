# Set the default layout generator to be rivercarro and start it.
# River will send the process group of the init executable SIGTERM on exit.
riverctl default-layout rivercarro
riverctl output-layout rivercarro
rivercarro -inner-gaps 0 -outer-gaps 0 -per-tag &

