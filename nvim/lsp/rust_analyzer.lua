local configure_rust_for_win32_cross_compilation = false

return {
  settings = {
    ["rust-analyzer"] = (function()
      if configure_rust_for_win32_cross_compilation then
        return {
          cargo = {
            target = "x86_64-pc-windows-gnu"
          },

          checkOnSave = {
            command = "clippy",
            extraArgs = { "--target", "x86_64-pc-windows-gnu" }
          },
        }
      else
        return {}
      end
    end)(),
  }

}
