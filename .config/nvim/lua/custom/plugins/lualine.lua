local function get_lualine_colors()
  local c = require('material.colors.init').main
  --c.bg = c.bg_dark
  --c.bg_dark = c.bg

  return c
end

local function get_kirby_colors()
  local colors = get_lualine_colors()

  return {
    n = colors.red,
    i = colors.green,
    v = colors.blue,
    [''] = colors.blue,
    V = colors.blue,
    c = colors.mauve,
    no = colors.red,
    s = colors.orange,
    S = colors.orange,
    [''] = colors.orange,
    ic = colors.yellow,
    R = colors.violet,
    Rv = colors.violet,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    ['r?'] = colors.cyan,
    ['!'] = colors.red,
    t = colors.red,
  }
end

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand '%:t') ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand '%:p:h'
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local function cond_disable_by_ft()
  local not_empty = conditions.buffer_not_empty()
  local filetype = vim.api.nvim_get_option_value('filetype', { buf = 0 })

  local filetype_to_ignore = {
    'terminal',
    'help',
    'alpha',
    'dashboard',
    'neo-tree',
    'Trouble',
    'trouble',
    'lazy',
    'mason',
    'notify',
    'toggleterm',
    'dapui_stacks',
    'toggleterm',
    'lazyterm',
    'fzf',
  }

  if vim.tbl_contains(filetype_to_ignore, filetype) then
    return false
  end

  return not_empty
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'marko-cerovac/material.nvim',
    'AndreM222/copilot-lualine',
  },
  options = {
    theme = 'material-nvim',
  },
  event = 'VeryLazy',
  priority = 900,
  enabled = true,
  opts = function()
    local colors = get_lualine_colors()

    local tokyo = require 'lualine.themes.material-nvim'

    tokyo.normal.a.fg = colors.yellow
    tokyo.insert.a.fg = colors.darkgreen
    tokyo.visual.a.fg = colors.paleblue
    tokyo.command.a.fg = colors.teal

    tokyo.normal.a.bg = colors.base
    tokyo.insert.a.bg = colors.base
    tokyo.visual.a.bg = colors.base
    tokyo.command.a.bg = colors.base
    tokyo.replace.a.bg = colors.base
    tokyo.inactive.a.bg = colors.base
    --tokyo.terminal.a.bg = colors.base

    tokyo.normal.b.bg = colors.base
    tokyo.insert.b.bg = colors.base
    tokyo.visual.b.bg = colors.base
    tokyo.command.b.bg = colors.base
    tokyo.replace.b.bg = colors.base
    tokyo.inactive.b.bg = colors.base
    --tokyo.terminal.b.bg = colors.base

    tokyo.normal.c.bg = colors.base
    tokyo.inactive.c.bg = colors.base

    local kirby_default = '(>*-*)>'

    local signs = {
      file = {
        modified = '',
        not_saved = '󰉉 ',
        readonly = '󰌾',
        created = '',
        unnamed = 'No Name',
      },
      git = {
        added = ' ',
        modified = ' ',
        removed = ' ',
        renamed = '󰑕 ',
        branch = '',
        ignored = ' ',
        unstaged = '󰄱 ',
        staged = ' ',
        untracked = '',
        -- added = " ",
        -- modified = " ",
        -- removed = " ",
      },
      fzf = {
        git = {
          added = '',
          modified = '',
          removed = '',
          renamed = '󰑕',
        },
      },
      full_diagnostic = {
        ok = '',
        error = ' ',
        warning = ' ',
        warn = ' ',
        info = ' ',
        hint = ' ',
        -- other = "󰠠 ",
      },
      diagnostic = {
        error = '●',
        warning = '●',
        warn = '●',
        info = '●',
        hint = '●',
        ok = '●',
        other = '●',
      },
      others = {
        copilot = ' ',
        copilot_disabled = ' ',
        terminal = ' ',
      },
    }

    local mode_kirby = {
      n = '<(•ᴗ•)>',
      i = '>(xᴗx)>',
      v = '(v•-•)v',
      [''] = '(v•-•)>',
      V = '(>•-•)>',
      c = kirby_default,
      no = '<(•ᴗ•)>',
      s = kirby_default,
      S = kirby_default,
      [''] = kirby_default,
      ic = kirby_default,
      R = kirby_default,
      Rv = kirby_default,
      cv = '<(•ᴗ•)>',
      ce = '<(•ᴗ•)>',
      r = kirby_default,
      rm = kirby_default,
      ['r?'] = kirby_default,
      ['!'] = '<(•ᴗ•)>',
      t = '<(•ᴗ•)>',
    }

    local sections = {
      lualine_a = {
        {
          'mode',
          -- icons_enabled = true,
          fmt = function()
            return mode_kirby[vim.fn.mode()] or vim.api.nvim_get_mode().mode
          end,
          separator = { right = '', left = '' },

          color = {
            bg = colors.base,
          },
          padding = { left = 0, right = 0 },
        },
      },
      lualine_b = {
        {
          'progress',
          separator = { right = '' },
          color = { fg = colors.darkcyan, bg = colors.base },
          padding = { left = 2, right = 0 },
        },
        {
          'location',
          separator = { right = '' },
          color = { fg = colors.darkcyan, bg = colors.base },
          padding = { left = 1, right = 0 },
        },
        {
          function()
            if vim.fn.mode():find '[vV]' then
              local ln_beg = vim.fn.line 'v'
              local ln_end = vim.fn.line '.'

              local lines = ln_beg <= ln_end and ln_end - ln_beg + 1 or ln_beg - ln_end + 1

              return 'sel: ' .. tostring(vim.fn.wordcount().visual_chars) .. ' | ' .. tostring(lines)
            else
              return ''
            end
          end,
          color = { fg = colors.darkcyan, bg = colors.base },
          separator = { right = '' },
        },
      },
      lualine_c = {
        {
          function()
            local msg = ' No Active Lsp'
            local text_clients = ''

            local clients = vim.lsp.get_clients { bufnr = 0 }
            if next(clients) == nil then
              return msg
            end
            for _, client in ipairs(clients) do
              if client.name ~= 'copilot' then
                text_clients = text_clients .. client.name .. ', '
              end
            end
            if text_clients ~= '' then
              return text_clients:sub(1, -3)
            end
            return msg
          end,
          icon = ' ',
          color = { fg = colors.red, bg = colors.base },
          padding = { left = 3, right = 0 },
          separator = { right = '', left = '' },
        },
        {
          'diagnostics',
          sources = { 'nvim_lsp' },
          symbols = signs.full_diagnostic,
          -- diagnostics_color = {
          -- 	error = { fg = c.error },
          -- 	warn = { fg = c.warn },
          -- 	info = { fg = c.info },
          -- 	hint = { fg = c.hint },
          -- },
          colored = true,
          color = { bg = colors.base },
          padding = { left = 3, right = 1 },
        },
      },
      lualine_x = {},
      lualine_y = {
        {
          'branch',
          icon = signs.git.branch,
          color = { fg = colors.green, bg = colors.base },
          separator = { right = '', left = '' },
        },
        {
          'diff',
          colored = true,
          source = diff_source,
          symbols = {
            added = signs.git.added,
            modified = signs.git.modified,
            removed = signs.git.removed,
          },
          diff_color = {
            -- Same color values as the general color option can be used here.
            added = 'LuaLineDiffAdd', -- Changes the diff's added color
            modified = 'LuaLineDiffChange', -- Changes the diff's modified color
            removed = 'LuaLineDiffDelete', -- Changes the diff's removed color you
          },
          color = { bg = colors.base },
          -- diff_color = {
          -- 	added = { gui = "bold" },
          -- 	modified = { gui = "bold" },
          -- 	removed = { gui = "bold" },
          -- },
        },
      },
      lualine_z = {
        {
          'filetype',
          color = { bg = colors.base, fg = colors.yellow },
          separator = { right = '', left = '' },
          cond = cond_disable_by_ft,
          icon_only = true,
          colored = false,
          padding = { right = 0, left = 0 },
          condition = conditions.buffer_not_empty,
        },
        {
          'filename',

          padding = { right = 1, left = 0 },
          color = { bg = colors.base, fg = colors.yellow },
          separator = { right = '', left = '' },

          symbols = {
            modified = signs.file.modified, -- Text to show when the file is modified.
            readonly = signs.file.readonly, -- Text to show when the file is non-modifiable or readonly.
            unnamed = signs.file.unnamed, -- Text to show for unnamed buffers.
            newfile = signs.file.created, -- Text to show for newly created file before first write
          },
        },
      },
    }

    local config = {
      options = {
        theme = tokyo,
        disabled_filetypes = { statusline = { 'alpha', 'snacks_dashboard' } },
        icons_enabled = true,
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        -- section_separators = "",
      },
      sections = sections,
      inactive_sections = sections,
    }

    -- ins_left()

    return config
  end,
  config = function(_, opts)
    require('lualine').setup(opts)
  end,
}
