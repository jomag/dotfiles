
vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  callback = function()
    if vim.bo.modified then
      print("Autosaving modified buffers...")
      vim.cmd("silent! wa")
    end
  end,
})
