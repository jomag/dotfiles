return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		position = "bottom",
		height = 10,
		auto_open = true,
		auto_close = true,

		-- For plain, non-nerd fonts
		icons = false,
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
