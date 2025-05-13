local lspconfig = require 'lspconfig'

return {
  init_options = {
    lint = true,
  },
  root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
}
