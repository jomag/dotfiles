-- Move line up/down with Akt+k and Alt+j
vim.keymap.set('n', '<A-k>', ':m -2<CR>==')
vim.keymap.set('n', '<A-j>', ':m +1<CR>==')

-- Move line up/down with Option+k and Option+j (MacOS)
vim.keymap.set('n', '˚', ':m -2<CR>==')
vim.keymap.set('n', '∆', ':m +1<CR>==')

-- Go to next/previous diagnostics entry (warning, error, ...)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)

-- Go to next/previous *error*
vim.keymap.set("n", "]e", function ()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end)
vim.keymap.set("n", "[e", function ()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)

-- Show extra diagnostics for the error under cursor
vim.keymap.set('n', '<leader>dd', function()
  vim.diagnostic.open_float()
end)

-- Alternate between the two most recently used buffers
-- Other alternatives to consider: `:bnext`
vim.api.nvim_set_keymap('n', '<Leader><Tab>', ':b#<CR>', { noremap = true, silent = true })
