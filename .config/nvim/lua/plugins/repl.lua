return {
  'pappasam/nvim-repl',
  lazy = false,
  config = function()
    require('repl').setup {
      filetype_commands = {
        javascript = { cmd = 'deno repl', filetype = 'javascript' },
      },
      default = { cmd = 'bash', filetype = 'bash' },
      open_window_default = 'vertical split new',
    }
  end,
  keys = {
    -- { '<C-Space>', '<Plug>(ReplSendCell)', mode = 'n', desc = 'ReplSendCell' },
    { '<leader>r', '<Plug>(ReplSendLine)', mode = 'n', desc = 'ReplSendLine' },
    { '<leader>r', '<Plug>(ReplSendVisual)', mode = 'x', desc = 'ReplSendVisual' },
  },
}
