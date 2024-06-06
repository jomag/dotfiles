return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},

	opts = {
		auto_close = true,
		auto_open = true,
		win = {
			position = "bottom",
		},
		height = 10,

		-- For plain, non-nerd fonts
		--icons = false,
		fold_open = "v",
		fold_closed = ">",
		indent_lines = false,
		signs = {
			error = "ERR",
			warning = "WARN",
			hint = "HINT",
			information = "INFO"
		},
		use_diagnostics_signs = false
	},
}
