require('nvim-tree').setup {
  sort = {
    sorter = 'case_sensitive',
  },
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
    custom = { '*.meta' },
  },
  update_focused_file = {
    enable = true,
  },
}
