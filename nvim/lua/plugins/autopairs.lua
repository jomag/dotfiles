return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require('nvim-autopairs').setup({
      -- Enable treesitter
      check_ts = true,

      ts_config = {
        -- Don't add pairs in Lua string treesitter nodes
        lua = { "string" },

        -- Don't add pairs in Javascript template_string treesitter nodes
        javascript = { "template_string" },

        -- Don't check treesitter on Java (why? don't know, followed YT example...)
        java = false,
      }
    })

    -- Make autopairs and nvim-cmp work together...
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
