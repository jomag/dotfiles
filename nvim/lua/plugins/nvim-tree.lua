return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  enabled = true,
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        width = {
          min = 10,
          max = 40,
        },
        side = 'left',
      },
      renderer = {
        group_empty = true,
        icons = {
          git_placement = 'right_align',
          modified_placement = 'right_align',
          bookmarks_placement = 'right_align',
        },
      },
      filters = {
        dotfiles = true,
        custom = { '*.meta' },
      },
      update_focused_file = {
        enable = true,
      },
    }
  end,
}
