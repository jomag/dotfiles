vim.o.cmdheight = 0

vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = "*",
  callback = function()
    vim.o.cmdheight = 1
  end
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "*",
  callback = function()
    vim.o.cmdheight = 0
  end
})
