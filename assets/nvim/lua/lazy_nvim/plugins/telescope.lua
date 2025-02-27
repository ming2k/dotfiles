-- if true then
--   return {}
-- end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
    event = { "VimEnter" },
    config = function()

      local function get_layout_config()
        local width = vim.o.columns
        if width > 200 then
          return {
            layout_strategy = 'horizontal',
            layout_config = {
              width = 0.9,
              height = 0.9,
              preview_width = 0.5,
            }
          }
        else
          return {
            layout_strategy = 'vertical',
            layout_config = {
              width = 0.9,
              height = 0.9,
              -- preview_height = 0.5,
              preview_cutoff = 20,
            }
          }
        end
      end

      local telescope = require("telescope")
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')

      telescope.setup {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case'
        },
        defaults = vim.tbl_deep_extend("force",
        {
          mappings = {
            i = {
              ["<C-c>"] = actions.close
            }
          }
        }, get_layout_config()),
        pickers = {
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            theme = "dropdown",
            previewer = false,
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              }
            }
          }
        }
      }

      -- File search with common exclusions
      vim.keymap.set('n', '<leader>ff', function()
        builtin.find_files({
          hidden = true,
          file_ignore_patterns = {
            "^.git/",
            "^node_modules/",
            "^dist/"
          }
        })
      end)
      
      -- File search with no exclusions (find all files)
      vim.keymap.set('n', '<leader>fF', function()
        builtin.find_files({
          hidden = true,
          no_ignore = true,  -- Include files that are typically ignored
        })
      end)
      
      -- Text search (grep) with common exclusions
      vim.keymap.set('n', '<leader>fg', function()
        builtin.live_grep({
          additional_args = function()
            return {
              "--glob", "!**/.git/**",
              "--glob", "!**/node_modules/**",
              "--glob", "!**/dist/**"
            }
          end
        })
      end, { desc = 'Telescope live grep with exclusions' })
      
      -- Text search (grep) with no exclusions (search all files)
      vim.keymap.set('n', '<leader>fG', function()
        builtin.live_grep({
          no_ignore = true,
          hidden = true
        })
      end, { desc = 'Telescope live grep (all files)' })
      
      -- Buffer management
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })

      -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {
        extensions = {
          file_browser = {},
        },
      }
      require("telescope").load_extension("file_browser")
      vim.keymap.set("n", "<leader>fe", ":Telescope file_browser<CR>")
    end
  },
}
