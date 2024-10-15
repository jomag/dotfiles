-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next hunk' })

        map({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous hunk' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = false }
        end, { desc = 'git blame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, { desc = 'git diff against last commit' })

        -- Toggles
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
      end,
    },
  },

  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   lazy = false,
  --   config = function()
  --     require('onedark').setup {
  --       -- Set a style preset. 'dark' is default.
  --       style = 'dark', -- dark, darker, cool, deep, warm, warmer, light
  --     }
  --     require('onedark').load()
  --   end,
  -- },

  -- {
  --   "lalitmee/cobalt2.nvim",
  --   event={"ColorSchemePre"},
  --   dependencies= {"tjdevries/colorbuddy.nvim" },
  --   init = function ()
  --     require("colorbuddy").colorscheme("cobalt2")
  --   end,
  -- },

  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },

  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function() end,
  },

  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function() end,
  },

  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function() end,
  },

  -- Not using anymore: replaced with tmux.
  -- {
  --   "akinsho/toggleterm.nvim",
  --   version = "*",
  --   opts = {},
  -- },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateRight',
      'TmuxNavigateUp',
      'TmuxNavigateDown',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>',  '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>',  '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>',  '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>',  '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- Import all dependencies from .config/nvim/lua/plugins
  { import = 'plugins' },
}, {})
