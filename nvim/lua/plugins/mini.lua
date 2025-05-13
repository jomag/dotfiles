return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    -- mini.ai enhances textobjects. For example:
    -- `vaa`  Visually select Around Argument
    -- `vana` Visually select Around Next Argument
    -- `vala` Visually select Around Last (previous) Argument
    require('mini.ai').setup()

    -- require('mini.files').setup()
    -- require('mini.statusline').setup()
  end,
}
