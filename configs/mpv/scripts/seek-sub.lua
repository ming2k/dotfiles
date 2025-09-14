mp.add_key_binding("a", "prev-subtitle-replay", function()
    mp.command("sub-seek -1")
    mp.command("set pause no")
end)

mp.add_key_binding("s", "replay-current-subtitle", function()
    mp.command("sub-seek 0")
    mp.command("set pause no")
end)

mp.add_key_binding("d", "next-subtitle", function()
    mp.command("sub-seek 1")
    mp.command("set pause no")
end)
