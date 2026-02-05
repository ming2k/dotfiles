-- Translate current subtitle using nllb-translate
-- Keybind: t

local function translate_sub()
    local sub = mp.get_property("sub-text")
    if not sub or sub == "" then
        mp.osd_message("No subtitle to translate")
        return
    end

    mp.osd_message("Translating...", 10)

    local res = mp.command_native({
        name = "subprocess",
        args = {"opus-translate-en-zh", sub},
        playback_only = false,
        capture_stdout = true,
        capture_stderr = true,
    })

    if res.status == 0 and res.stdout then
        local translated = res.stdout:gsub("^%s+", ""):gsub("%s+$", "")
        mp.osd_message(translated, 5)
    else
        mp.osd_message("Translation failed")
    end
end

mp.add_key_binding("t", "translate-sub", translate_sub)
