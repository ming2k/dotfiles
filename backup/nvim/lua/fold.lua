vim.opt.foldenable = true
-- Enable folding using Treesitter expression
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()' 
-- Keep all folds open by default
vim.opt.foldlevel = 99   
vim.opt.foldlevelstart = 99
-- Set to "0" to hide the fold column
-- Set to "1" to show fold indicators
vim.opt.foldcolumn = "0" 

-- Automatically save fold states when leaving a buffer
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*",
  callback = function()
    if vim.fn.expand('%') ~= '' and not vim.fn.expand('%:p'):match('^/tmp') then
      pcall(vim.cmd, 'mkview')
    end
  end
})

-- Automatically load fold states when entering a buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    if vim.fn.expand('%') ~= '' and not vim.fn.expand('%:p'):match('^/tmp') then
      pcall(vim.cmd, 'silent! loadview')
    end
  end
})
