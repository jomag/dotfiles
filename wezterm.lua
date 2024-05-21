local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "terafox"
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 13
config.colors = {
	background = "black",
}
config.macos_window_background_blur = 20
config.window_background_opacity = 0.7
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}
config.hide_tab_bar_if_only_one_tab = true

return config
