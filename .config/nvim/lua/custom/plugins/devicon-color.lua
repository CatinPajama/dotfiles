return {
  'rachartier/tiny-devicons-auto-colors.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'rebelot/kanagawa.nvim',
  },
  event = 'VeryLazy',
  config = function()
    local palette = require('kanagawa.colors').setup().palette

    require('tiny-devicons-auto-colors').setup(palette)
  end,
}
