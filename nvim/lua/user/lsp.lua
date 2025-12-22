vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    -- Wrapper around vim.keymap.set with improved description
    local bind = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { desc = desc })
    end

    bind('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    vim.keymap.set({ 'x', 'n', }, '<leader>ca', function ()
      vim.lsp.buf.code_action({
        context = {
          -- only = { 'quickfix', 'refactor', 'source '}
        }
      })
    end, { desc = '[C]ode [A]ction'})

    -- "Go to" keybindings
    -- bind('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    -- bind('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    -- bind('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    -- bind('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    -- bind('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    -- bind('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    -- bind('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- Show documentation for the item under the cursor
    bind('K', vim.lsp.buf.hover, 'Hover Documentation')
    bind('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Manage workspace folders
    bind('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    bind('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    bind('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = "Format buffer with LSP" })
  end
})

vim.lsp.enable({
  "clangd",
  "pyright",
  "rust_analyzer",
  -- "ts_ls",
  "vtsls",
  "html",
  -- "denols",
  "lua_ls",
  "cssls",
  "tailwindcss",
  "svelte",
  "graphql",
  "emmet_ls",
  "astro",
  "taplo",
})

local lspconfig = require('lspconfig')
