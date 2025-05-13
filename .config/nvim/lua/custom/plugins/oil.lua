return {
  'stevearc/oil.nvim',
  keys = {
    { '<leader>e', '<cmd>Oil --float<cr>', desc = 'open floating file explorer' },
  },
  opts = {},
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
}
