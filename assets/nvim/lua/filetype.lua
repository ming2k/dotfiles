-- Config behavior by filetypes

-- Assign types for unrecognized file types
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {
    ------
    -- Gentoo Portage Conf
    ------
    "/etc/portage/package.use",
    "/etc/portage/package.mask",
    "/etc/portage/package.unmask",
    "/etc/portage/package.accept_keywords",
    "/etc/portage/package.license",
    "/etc/portage/package.env",
    -- set for dir
    "/etc/portage/package.use/*",
    "/etc/portage/package.mask/*",
    "/etc/portage/package.unmask/*",
    "/etc/portage/package.accept_keywords/*",
    "/etc/portage/package.license/*",
    "/etc/portage/package.env/*",
    -------
    -- Dae
    -------
    "/etc/dae/config.dae"
  },
  callback = function()
    vim.bo.filetype = "conf"
  end
})

-- Set manual fold method for txt and conf files
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "conf" },
    callback = function()
        vim.opt_local.foldmethod = "manual"
        -- hint column
        vim.opt.colorcolumn = "80"
    end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function() 
    vim.opt.wrap = true
  end,

})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "jsx", "tsx" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ebuild",
  command = "setlocal ts=4 sts=4 sw=4 expandtab",
})

