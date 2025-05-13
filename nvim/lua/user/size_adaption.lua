-- Modify vim setup based on current width and height
local toggle_floating_file_tree = 100

local function on_width_change(width)
  print("Updating for new width:", width)
  if width < toggle_floating_file_tree then
  else

  end
end

vim.api.nvim_create_autocmd("VimResized", {
  callback = function(args)
    print("Resized...")
  end
  --   -- pattern = "*",
  --   callback = function()
  --     print("Received callback")
  --     on_width_change(vim.wo.columns)
  --   end
})

-- print("Starting up")
