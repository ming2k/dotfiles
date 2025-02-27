-- More efficient way to check if running in getty/tty
local function is_getty()
    -- Primary check: TERM environment variable
    if vim.env.TERM == "linux" then
        return true
    end
    
    -- Secondary check: tty path
    local tty = vim.fn.system("tty"):gsub("%s+", "")  -- Remove whitespace
    return tty:match("^/dev/tty%d+$") ~= nil
end

-- Set colorscheme based on terminal type
if is_getty() then
    -- More explicit Visual mode reverse for TTY
    vim.api.nvim_set_hl(0, 'Visual', { reverse = true })
    -- vim.api.nvim_set_hl(0, 'Visual', {
    --     cterm = { reverse = true }
    -- })
else
    -- Use your preferred colorscheme for graphical terminals
    vim.opt.background = "light"
    vim.api.nvim_set_hl(0, 'Visual', {
        bg = '#3c4c6d',
        fg = '#f0f0f0',
        bold = true,
    })
end
