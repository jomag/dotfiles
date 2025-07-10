local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Goes well with the Terafox Neovim theme
-- config.color_scheme = "terafox"

-- Goes well with the Tokyo Night Neovim theme
config.color_scheme = "Tokyo Night"

-- Goes well with the Catpuccin Neovim theme
-- config.color_scheme = "Catppuccin Mocha"

-- config.font = wezterm.font("CaskaydiaMono Nerd Font")
-- config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font = wezterm.font("Hack Nerd Font Mono")

config.font_size = 12
-- config.line_height = 1.2

-- config.colors = {
-- 	background = "black",
-- }

-- config.macos_window_background_blur = 20
-- config.window_background_opacity = 0.8

config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
}

-- Overrides for windows
if not not os.getenv("HOMEDRIVE") then
	-- config.font = wezterm.font("CaskaydiaMono Nerd Font Mono")
	config.font = wezterm.font("Hack Nerd Font Mono")
	config.font_size = 10
	config.window_background_opacity = 1.0
	config.window_decorations = "RESIZE"
end

--

config.automatically_reload_config = true

return config
