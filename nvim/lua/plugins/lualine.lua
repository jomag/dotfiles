return {
	-- Set lualine as statusline
	'nvim-lualine/lualine.nvim',
	config = function()
		require('lualine').setup {
			options = {
				-- If true, a single status line is used for all buffers
				globalstatus = false,

				icons_enabled = true,
				theme = 'auto',
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				refresh = {
					statusline = 100,
					tabline = 100,
					winbar = 100,
				},
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = {},
				-- lualine_b = { 'branch', 'diff', 'diagnostics' },
				-- Path: 0 = filename only, 1 = relative path, 2-3 = abs path, 4 = filename and parent directory
				lualine_c = { { 'filename', path = 4 } },
				lualine_x = { 'encoding', 'fileformat', 'filetype' },
				lualine_y = { 'progress' },
				lualine_z = { 'location' },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { 'filename' },
				lualine_x = { 'location' },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		}
	end,
}
