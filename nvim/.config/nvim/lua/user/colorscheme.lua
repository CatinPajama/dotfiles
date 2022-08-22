local colorscheme = "tokyonight"

vim.g.tokyonight_transparent = true

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end