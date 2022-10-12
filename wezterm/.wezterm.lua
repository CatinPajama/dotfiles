local wezterm = require 'wezterm'

local carbonfox_light = wezterm.color.get_builtin_schemes()['carbonfox']


carbonfox_light.background = "#ffffff"
carbonfox_light.foreground = "#90a4ae"
carbonfox_light.selection_bg = "#aed481"
carbonfox_light.selection_fg = "#ffffff"
carbonfox_light.cursor_bg = "#aed481"

return {
  font = wezterm.font 'RobotoMono Nerd Font',
  font_size = 14,
  window_padding = {
    left = 15,
    right = 24,
    top = 6,
    bottom = 24,
  },
  hide_tab_bar_if_only_one_tab = true,
  color_schemes = {
    ['carbonfox light'] = carbonfox_light
  },
  color_scheme = "carbonfox light"
}
