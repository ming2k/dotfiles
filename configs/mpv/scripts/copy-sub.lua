-- Copy current subtitle to clipboard
-- Keybind: y

local function copy_sub()
    local sub = mp.get_property("sub-text")
    if not sub or sub == "" then
        mp.osd_message("No subtitle to copy")
        return
    end

    -- Try wl-copy (Wayland), then xclip (X11)
    local commands = {
        {"wl-copy", "--"},
        {"xclip", "-selection", "clipboard"},
    }

    for _, cmd in ipairs(commands) do
        local args = {name = "subprocess", args = cmd, playback_only = false, capture_stdout = true, capture_stderr = true}
        args.args[#args.args + 1] = sub

        local res = mp.command_native(args)
        if res.status == 0 then
            mp.osd_message("Copied: " .. sub:sub(1, 50) .. (sub:len() > 50 and "..." or ""))
            return
        end
    end

    mp.osd_message("Failed to copy (install xclip or wl-copy)")
end

mp.add_key_binding("y", "copy-sub", copy_sub)
