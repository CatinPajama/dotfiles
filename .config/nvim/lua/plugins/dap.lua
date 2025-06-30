return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap-python',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      require('dapui').setup()
      require('dap-python').setup 'python3'
      require('nvim-dap-virtual-text').setup {
        -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if name:match 'secret' or name:match 'api' or value:match 'secret' or value:match 'api' then
            return '*****'
          end

          if #variable.value > 15 then
            return ' ' .. string.sub(variable.value, 1, 15) .. '... '
          end

          return ' ' .. variable.value
        end,
      }

      -- Handled by nvim-dap-go
      -- dap.adapters.go = {
      --   type = "server",
      --   port = "${port}",
      --   executable = {
      --     command = "dlv",
      --     args = { "dap", "-l", "127.0.0.1:${port}" },
      --   },
      -- }

      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint, { desc = 'toggle breakpoint' })
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor, { desc = 'run to cursor' })

      -- Eval var under cursor
      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)

      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[c]ontinue' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step [i]nto' })
      vim.keymap.set('n', '<leader>d0', dap.step_over, { desc = 'Step [0]ver' })
      vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'Step [o]ut' })
      vim.keymap.set('n', '<leader>db', dap.step_back, { desc = 'Step [b]ack' })
      vim.keymap.set('n', '<leader>dr', dap.restart, { desc = '[r]estart' })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
