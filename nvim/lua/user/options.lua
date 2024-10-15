-- Use nerd font with cute icons?
-- FIXME: does not seem to change anything
vim.g.have_nerd_font = false

-- On split, create the new pane to the right or below
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Enable mouse in all modes
vim.opt.mouse = 'a'

-- Ignore case for better searching, unless search criteria includes capital letters
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Support many colors (requires terminal support)
vim.opt.termguicolors = true

-- Enable access to system clipboard
vim.opt.clipboard = 'unnamed,unnamedplus'

-- Highlight the current cursor line
vim.opt.cursorline = true

-- Make sure some lines before/after the current line are always visible
vim.opt.scrolloff = 4

-- Indicate the 80'th and 100'th column
-- vim.opt.colorcolumn = "80,100"

-- Ignore some files. DOES NOT SEEM TO WORK!
vim.opt.wildignore = '*.meta'

-- Default indentation is two spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.diagnostic.config {
  -- Enable to show errors "inline"
  virtual_text = true,
  underline = true,
}

-- Auto refresh buffers when they change
-- Source: https://stackoverflow.com/questions/62100785/
vim.o.autoread = true
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained' }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { '*' },
})

-- vim.lsp.set_log_level 'debug'
