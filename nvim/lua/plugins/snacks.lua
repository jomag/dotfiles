return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      enabled = true,
      sources = {
        explorer = {
          auto_close = true,
          hidden = true
        }
      }
    },
    explorer = {
      replace_netrw = true,
      enabled = true,
    }
  },
  keys = {
    -- Top pickers and explorer
    { "<leader>sf", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
    { "<leader>,",  function() Snacks.picker.buffers() end,               desc = "Buffers" },
    { "<leader>/",  function() Snacks.picker.grep() end,                  desc = "Grep" },
    { "<leader>:",  function() Snacks.picker.command_history() end,       desc = "Command History" },
    { "<leader>n",  function() Snacks.picker.notifications() end,         desc = "Notification History" },
    { "<leader>e",  function() Snacks.explorer() end,                     desc = "FileExplorer" },

    -- LSP
    { "gd",         function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
    { "gD",         function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
    { "gr",         function() Snacks.picker.lsp_references() end,        desc = "References",            nowait = true },
    { "gI",         function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
    { "gy",         function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
  }
}
