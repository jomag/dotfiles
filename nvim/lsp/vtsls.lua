local lspconfig = require('lspconfig')

-- lspconfig.vtsls.setup({
--   on_attach = function(client, bufnr)
--     print("Should have source config soooon")
--     local opts = { noremap = true, silent = true, buffer = bufnr }
--
--     -- Custom keymaps just for vtsls
--     if client.name == "vtsls" then
--       vim.keymap.set("n", "<leader>oi", "<cmd>VtsExec organize_imports<CR>", opts)
--       vim.keymap.set("n", "<leader>rf", "<cmd>VtsExec rename_file<CR>", opts)
--       vim.keymap.set("n", "<leader>im", "<cmd>VtsExec import_all<CR>", opts)
--     end
--   end
-- })
--
--
--
return {
  -- root_dir = function(filename, bufnr)
  --   -- `vtsls` should be disabled in Deno projects, as it conflicts with `denols`
  --   if lspconfig.util.root_pattern('deno.json', 'deno.jsonc')(filename) then
  --     return nil
  --   end
  --   return lspconfig.util.root_pattern 'package.json' (filename)
  -- end,

  -- For `vtsls` to be disabled in Deno projects
  -- single_file_support = false,

  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },

  on_attach = function(client, bufnr)
    local vtsls = require('vtsls')
    -- Map gD to go to source definition using vtsls
    vim.keymap.set("n", "gD", function()
      vtsls.commands.goto_source_definition()
    end, { buffer = bufnr, desc = "Go to Source Definition" })

    -- You can add other vtsls helpers here too
    -- vim.keymap.set("n", "<leader>co", vtsls.commands.organize_imports, { buffer = bufnr, desc = "Organize Imports" })
  end,
}
