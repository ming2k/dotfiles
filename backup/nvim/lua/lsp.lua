-- Function to detect project type based on files present
local function detect_project()
  -- Define root markers for different project types
  local root_markers = {
      lua = { 'init.lua', 'config.lua', '.luacheckrc', '.stylua.toml' },
      python = { 'pyproject.toml', 'setup.py', 'requirements.txt' },
      c = { 'Makefile', 'CMakeLists.txt', '.clang-format', '.clang-tidy' },
      cpp = { 'Makefile', 'CMakeLists.txt', '.clang-format', '.clang-tidy', 'compile_commands.json' },
      rust = { 'Cargo.toml' },
      go = { 'go.mod', 'go.sum', 'Gopkg.toml', 'glide.yaml' },
      java = { 'pom.xml', 'build.gradle', '.gradle', 'gradlew', '.idea', '.eclipse' },
      javascript = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
  }

  -- Check for each project type
  for project_type, markers in pairs(root_markers) do
      local root_dir = vim.fs.root(0, markers)
      if root_dir then
          return project_type, root_dir
      end
  end

  -- If no project is detected, return nil
  return nil, nil
end


-- Function to check if the LSP server is installed
local function is_lsp_installed(lsp_server)
return vim.fn.executable(lsp_server) == 1
end

-- Table of LSP configurations for different project types
local lsp_configs = {
lua = {
  name = "lua-language-server",  -- Executable name
  config = require('lsp_configurations.lua_ls')
},
python = {
  name = "pyright",  -- Executable name
  config = require('lsp_configurations.pyright')
},
c = {
  name = "clangd",  -- Executable name
  config = require('lsp_configurations.clangd')
},
cpp = {
  name = "clangd",  -- Executable name
  config = require('lsp_configurations.clangd')
},
rust = {
  name = "rust-analyzer",  -- Executable name
  config = require('lsp_configurations.rust_analyzer')
},
go = {
  name = "gopls",  -- Executable name
  config = require('lsp_configurations.gopls')
},
javascript = {
  name = "tsserver",  -- Executable name
  config = require('lsp_configurations.ts_ls')
},
}

-- Function to set up LSP for a project
local function setup_lsp_for_project(lsp_config)
local lsp_server = lsp_config.name  -- Get the LSP server name
if not is_lsp_installed(lsp_server) then
  print("LSP server " .. lsp_server .. " is not installed.")
  return
end

local client_id = vim.lsp.start_client(lsp_config)
-- if client_id then
--   vim.lsp.buf_attach_client(0, client_id)
-- end
end

-- Autocmd to set up LSP when a buffer is read
vim.api.nvim_create_autocmd("BufReadPost", {
callback = function()
  local project_type, project_root = detect_project()
  if project_type and lsp_configs[project_type] then
    local config = vim.tbl_deep_extend("force", lsp_configs[project_type].config, {
      root_dir = project_root,
    })
    setup_lsp_for_project(config)
  end
end,
})

-- Keymap for LSP rename
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, {noremap=true, silent=true})
