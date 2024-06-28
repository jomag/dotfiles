return {
  'nvim-treesitter/nvim-treesitter',

  dependencies = {
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
    }
  end,
}
