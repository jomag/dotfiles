-- Move line up/down with Akt+k and Alt+j
vim.keymap.set('n', '<A-k>', ':m -2<CR>==')
vim.keymap.set('n', '<A-j>', ':m +1<CR>==')

-- Move line up/down with Option+k and Option+j (MacOS)
vim.keymap.set('n', '˚', ':m -2<CR>==')
vim.keymap.set('n', '∆', ':m +1<CR>==')

-- Keybindings for Trouble (defaults)
-- vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle("diagnostics") end)
-- vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
-- vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
-- vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
-- vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
-- vim.keymap.set("n", "<leader>xn", function() require("trouble").next({ skip_groups = true, jump = true }) end)
-- vim.keymap.set("n", "<leader>xp", function() require("trouble").previous({ skip_groups = true, jump = true }) end)
-- vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

-- Keybindings for Trouble, my customized versions
-- vim.keymap.set("n", "<F8>", function() require("trouble").next({ mode = "diagnostics", skip_groups = true, jump = true }) end)
-- vim.keymap.set("n", "<S-F8>", function() require("trouble").previous({ skip_groups = true, jump = true }) end)
vim.keymap.set('n', '<F8>', function()
  vim.diagnostic.goto_next()
end)

vim.keymap.set('n', '<leader>dd', function()
  vim.diagnostic.open_float()
end)
