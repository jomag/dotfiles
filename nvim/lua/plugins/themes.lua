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
  },
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    -- you can set set configuration options here
    -- config = function()
    --     vim.g.zenbones_darken_comments = 45
    --     vim.cmd.colorscheme('zenbones')
    -- end
  },
  {
    "nyoom-engineering/oxocarbon.nvim"
    -- Add in any other configuration; 
    --   event = foo, 
    --   config = bar
    --   end,
  }
}
