return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    -- Linters by file type
    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = {},
      javascriptreact = { 'eslint_d' },
      typescriptreact = {},
      svelte = { 'eslint_d' },
      python = { 'pylint' },
    }



    -- Setup auto linting on certain events
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Keybinding to trigger linting for current file
    vim.keymap.set('n', '<leader>l', function()
      lint.try_lint()
    end, { desc = 'Trigger linting for current file' })
  end,
}
