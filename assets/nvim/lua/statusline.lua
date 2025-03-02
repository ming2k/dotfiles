--[[
  Required nerdfont, icon Selection Priority
  Since an icon may exist in multiple categories, the fonticon selection priority is as follows:
  1. nf-dev (Developer icons)
  2. nf-cod (VS Code icons)
  3. nf-fa (Font Awesome icons)
  
  The system will select icons according to the priority order above.
--]]

default_color = [[
  highlight StatusLine   guifg=#4a4a4a guibg=#f0f0f0 gui=NONE
  highlight StatusLineNC guifg=#8a8a8a guibg=#f0f0f0 gui=NONE
]]

-- Simple, minimal statusline with emojis
diagnostic_msg_color = [[
  highlight StError     guifg=#ffffff guibg=#e05252 gui=NONE
  highlight StWarn      guifg=#4a4a4a guibg=#ffcc66 gui=NONE
  highlight StHint      guifg=#4a4a4a guibg=#7dcfff gui=NONE
  highlight StInfo      guifg=#ffffff guibg=#787878 gui=NONE
]]

custom_component_color = [[
  highlight StMode      guifg=#4a4a4a guibg=#e0e0e0 gui=bold
  highlight StFile      guifg=#4a4a4a guibg=#f0f0f0 gui=NONE
  highlight StGit       guifg=#ffffff guibg=#f05033 gui=NONE
]]

status_line_color = default_color .. diagnostic_msg_color .. custom_component_color


vim.cmd(status_line_color)

-- Mode configurations with emojis
local modes = {
    ['n']    = ' NORMAL',    -- Search emoji for normal mode
    ['v']    = ' VISUAL',    -- Scissors for visual mode
    ['V']    = ' V·LINE',
    ['i']    = ' INSERT',    -- Pencil for insert mode
    ['ic']   = ' INSERT',
    ['R']    = ' REPLACE',   -- Sync emoji for replace mode
    ['Rv']   = ' V·REPLACE',
    ['c']    = ' COMMAND',   -- Computer for command mode
}

-- Function to get current mode
local function get_mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format('%%#StMode# %s ', modes[current_mode] or modes['n'])
end

-- Function to get git info with emoji
local function get_git_info()
    local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    if branch ~= "" then
        return string.format('%%#StGit#  %s ', branch)
    end
    return ''
end

-- Function to get file info with emoji
local function get_file_info()
    local file = vim.fn.expand('%:t')
    local full_path = vim.fn.expand('%:p:~')
    if file == '' then file = '[No Name]' end
    
    local file_icon = ' '  -- Default file icon

    local extension = vim.fn.expand('%:e')
    local file_icons = {
        html    = '',
        html    = '',
        js      = '',
        ts      = '',

        lua     = '',    -- Moon for Lua
        py      = '',     -- Snake for Python

        json    = '',   -- Package for JSON
        md      = '',     -- Memo for Markdown
        vim     = '',    -- Green heart for Vim
        sh      = '',     -- Shell for shell scripts
        -- Use [] to specify the specific file name
        ['.git'] = '', -- Notebook for git files
    }
    
    local icon = file_icons[extension] or file_icon
    local modified = vim.bo.modified and '*' or ''  -- Sparkle for modified
    
    --[[
      Provide more information if conditions permit
      This function will allow status bar shows full file path if width more than 80 columns
    --]]
    local window_width = vim.fn.winwidth(0)
    local display_path
    if window_width > 80 then
        -- Use full path if window is wide enough
        display_path = full_path
        
        -- Smart truncation if path is very long
        if #display_path > window_width / 2 then
            -- Keep the beginning (root) and filename, truncate the middle
            local path_parts = vim.fn.split(display_path, '/')
            if #path_parts > 3 then
                local start = path_parts[1]
                local middle = '...'
                local last_parts = table.concat({path_parts[#path_parts-1], path_parts[#path_parts]}, '/')
                display_path = start .. '/' .. middle .. '/' .. last_parts
            end
        end
    else
        -- Just use filename when window is narrow
        display_path = file
    end
    
    return string.format('%%#StFile# %s %s %s ', icon, display_path, modified)
end

-- Function to get diagnostic info with emojis
local function get_diagnostics()
    if vim.fn.exists('*vim.diagnostic.get') == 1 then
        local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        
        local status = ''
        if errors > 0 then status = status .. string.format(' %d ', errors) end
        if warnings > 0 then status = status .. string.format(' %d ', warnings) end
        if hints > 0 then status = status .. string.format('💡 %d ', hints) end
        return status
    end
    return ''
end

-- Function to get file position with emoji
local function get_position()
    local line = vim.fn.line('.')
    local col = vim.fn.col('.')
    local total_lines = vim.fn.line('$')
    local percent = math.floor(line * 100 / total_lines)
    return string.format('%%#StInfo#  %d:%d %d%%%% ', line, col, percent)
end

-- Set up the statusline
function StatusLine()
    local status = ''
    
    -- Left side
    status = status .. get_mode()
    status = status .. get_git_info()
    status = status .. get_file_info()
    status = status .. get_diagnostics()
    
    -- Right side
    status = status .. '%='  -- Switch to right side
    status = status .. get_position()
    
    return status
end

-- Apply the statusline
vim.opt.statusline = '%!v:lua.StatusLine()'
vim.opt.laststatus = 3  -- Global statusline
vim.opt.showmode = false  -- Don't show mode in command line

