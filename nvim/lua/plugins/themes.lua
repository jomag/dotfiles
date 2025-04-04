return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,

    config = function()
      require("tokyonight").setup({
        style                    = "storm",
        light_style              = "day",
        transparent              = false,
        terminal_colors          = true,
        styles                   = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark"
        },
        sidebars                 = { "qf", "help" },
        day_brightness           = 0.3,
        hide_inactive_statusline = false,
        dim_inactive             = false,
        lualine_bold             = false,

        ---@diagnostic disable-next-line: unused-local
        on_colors                = function(colors) end,

        ---@diagnostic disable-next-line: unused-local
        on_highlights            = function(highlights, colors) end,
      })
    end
  },
  {
    "rose-pine/neovim",
    lazy = false,
    priority = 1000,
    name = "rose-pine",
    config = function()
      -- Make the gutter stand out a bit.
      -- Default background of rose-pine-moon is #232136.
      -- This color is darkened by 10%
      local gutter_bg = "#1f1e31"

      require("rose-pine").setup({
        highlight_groups = {
          LineNr = { bg = gutter_bg },
          SignColumn = { bg = gutter_bg },
          CursorLineNr = { bg = gutter_bg }
        }
      })
    end
  }
}
