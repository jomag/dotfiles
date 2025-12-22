return {
  settings= {
    basedpyright ={
    analysis = {
      autoSearchPaths = true,
      diagnosticMode = 'openFilesOnly',
      useLibraryCodeForTypes = true,
        inlayHints = {
          callArgumentNames = true
        }
    },
    -- venvPath = vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV or vim.env.PYENV_ROOT,
  },
}
