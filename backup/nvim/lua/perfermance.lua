-- vim.opt.background = 'light'
-- vim.opt.background = 'dark'

local function is_getty()
    -- Check if TERM contains "getty"
    if vim.env.TERM and string.find(string.lower(vim.env.TERM), "getty") then
        return true
    end
    
    -- Alternative method: check if running in Linux console
    local handle = io.popen("tty", "r")
    if handle then
        local result = handle:read("*a")
        handle:close()
        if string.find(result, "/dev/tty%d+") then
            return true
        end
    end
    
    return false
end

-- Set background based on terminal type
if is_getty() then
    vim.opt.background = "dark"
else
    vim.opt.background = "light"
end



