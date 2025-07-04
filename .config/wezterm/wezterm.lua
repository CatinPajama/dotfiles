local wezterm = require("wezterm")
local config = wezterm.config_builder()
local matugen = require("colors.matugen")
--require("keys").setup(config)

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })
config.font_size = 9
config.line_height = 1.5
config.color_schemes = {
	["matugen"] = matugen,
}
config.color_scheme = "matugen"

config.window_padding = {
	left = 20,
	right = 15,
	top = 30,
	bottom = 0,
}
config.enable_tab_bar = false
config.enable_wayland = true
config.window_background_opacity = 0.98
return config
