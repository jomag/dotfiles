return {
  'nvim-treesitter/nvim-treesitter',

  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',

    -- Enable auto-closing and auto-renaming HTML tags
    'windwp/nvim-ts-autotag',
  },

  build = ':TSUpdate',

  config = function()
    require('nvim-treesitter.configs').setup {
      -- Enable syntax highlighting
      highlight = { enable = true },

      -- Enable indentation
      indent = { enable = true },

      -- Do syntax-aware selection with an increasingly growing scope
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },

      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'astro', 'css' },

      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      auto_install = false,

      -- Install languages synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- List of parsers to ignore installing
      ignore_install = {},

      -- You can specify additional Treesitter modules here:
      -- For example: -- playground = {--enable = true,-- },
      modules = {},

      -- Settings for the textobjects dependency
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = false,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    }
  end,
}
