-- Documentation: `:help ibl`
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {},
  config = function()
    require('ibl').setup {
      indent = { char = '▏' },

      -- I find the underline on the first line of the function/scope
      -- a bit distracting. It could also be disabled entirely.
      scope = { enabled = true, show_start = false, show_end = false },

      -- Disable indentation guides for buffer types where it's not needed
      exclude = { filetypes = { 'dashboard' } },
    }
  end,
}
