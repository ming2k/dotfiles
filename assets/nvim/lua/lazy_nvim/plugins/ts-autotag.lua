-- if true then
--   return {}
-- end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
    "windwp/nvim-ts-autotag",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter" }
    },
    opts = {
        filetypes = {
            'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
            'xml',
            'php',
            'markdown',
        },
    }
}
