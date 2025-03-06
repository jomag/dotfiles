return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },

  {
    'neovim/nvim-lspconfig',
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
    },
    config = function()
      local lspconfig = require 'lspconfig'

      local servers = {
        clangd = {},
        pyright = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = 'openFilesOnly',
              useLibraryCodeForTypes = true,
            },
            venvPath = vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV or vim.env.PYENV_ROOT,
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                target = "x86_64-pc-windows-gnu"
              },

              checkOnSave = {
                command = "clippy",
                extraArgs = { "--target", "x86_64-pc-windows-gnu" }
              },
            }
          }
        },
        ts_ls = {
          root_dir = function(filename, bufnr)
            -- `ts_ls` should be disabled in Deno projects, as it conflicts with `denols`
            if lspconfig.util.root_pattern('deno.json', 'deno.jsonc')(filename) then
              return nil
            end
            return lspconfig.util.root_pattern 'package.json' (filename)
          end,

          -- For `ts_ls` to be disabled in Deno projects
          single_file_support = false,

          filetypes = { 'typescript', 'typescriptreact' },
        },
        html = {},
        denols = {
          init_options = {
            lint = true,
          },
          root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
        },
        lua_ls = {},
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
          },
        },
        tailwindcss = {},
        svelte = {},
        graphql = {},
        emmet_ls = {},
        astro = {},
        taplo = {},
      }

      local function on_attach(foo, bufnr)
        -- Wrapper around vim.keymap.set with improved description
        local bind = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { desc = desc })
        end

        bind('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        bind('<leader>ca', function()
          vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
        end, '[C]ode [A]ction')

        -- "Go to" keybindings
        bind('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        bind('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        bind('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        bind('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        bind('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        bind('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        bind('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

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
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local mason_lspconfig = require 'mason-lspconfig'

      local ensure_installed = vim.tbl_keys(servers)

      mason_lspconfig.setup {
        ensure_installed = ensure_installed,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.on_attach = on_attach
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            lspconfig[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
