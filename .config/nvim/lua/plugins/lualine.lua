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
    local colors = require('kanagawa.colors').setup().palette
    -- local colors = require 'tokyonight.colors.night'
    colors.bg = 'none'
    local lualine_theme = require 'lualine.themes.kanagawa'
    -- local lualine_theme = require 'lualine.themes.tokyonight-storm'
    lualine_theme.normal.a.bg = colors.dragonAqua
    lualine_theme.insert.a.bg = colors.dragonGreen
    lualine_theme.visual.a.bg = colors.dragonViolet
    lualine_theme.command.a.bg = colors.dragonViolet
    -- lualine_theme.terminal.a.fg = colors.dragonViolet

    -- lualine_theme.command.a.fg = colors.yellow
    -- lualine_theme.normal.a.fg = colors.cyan
    -- lualine_theme.insert.a.fg = colors.green
    -- lualine_theme.visual.a.fg = colors.purple
    -- lualine_theme.command.a.fg = colors.yellow
    -- lualine_theme.terminal.a.fg = colors.magenta

    local modes = { 'normal', 'insert', 'visual', 'command', 'replace', 'inactive', 'terminal' }
    local section_list = { 'b', 'c' }

    for _, mode in ipairs(modes) do
      for _, section in ipairs(section_list) do
        if lualine_theme[mode] and lualine_theme[mode][section] then
          lualine_theme[mode][section].bg = colors.bg
        end
      end
    end

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
      n = '<(nᴗn)>',
      i = '>(;ᴗ;)>',
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
        --[[{
          'mode',
          -- icons_enabled = true,
          fmt = function()
            -- return '█'
            return ' ' .. mode_kirby[vim.fn.mode()] or vim.api.nvim_get_mode().mode
          end,
          separator = { right = ' ', left = '' },

          color = {},
          padding = { left = 0, right = 2 },
        },]]
        --
        {
          'filetype',
          -- color = { fg = colors.yellow },
          separator = { right = '', left = '' },
          cond = cond_disable_by_ft,
          icon_only = true,
          colored = false,
          padding = { right = 0, left = 1 },
          condition = conditions.buffer_not_empty,
        },

        {
          'filename',

          padding = { right = 1, left = 1 },
          color = { fg = colors.yellow },
          separator = { right = '', left = ' ' },

          symbols = {
            modified = signs.file.modified, -- Text to show when the file is modified.
            readonly = signs.file.readonly, -- Text to show when the file is non-modifiable or readonly.
            unnamed = signs.file.unnamed, -- Text to show for unnamed buffers.
            newfile = signs.file.created, -- Text to show for newly created file before first write
          },
        },
      },
      lualine_b = {
        --[[
        {
          'progress',
          separator = { right = '' },
          color = { fg = colors.green },
          padding = { left = 2, right = 0 },
        },
        ]]
        --
        {
          'location',
          separator = { right = '' },
          color = { fg = colors.green, bg = colors.bg },
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
          color = { fg = colors.blue },
          separator = { right = '' },
        },
      },
      lualine_c = {
        {
          'diagnostics',
          sources = { 'nvim_lsp' },
          symbols = signs.full_diagnostic,
          diagnostics_color = {
            error = { fg = colors.dragonRed },
            warn = { fg = colors.dragonYellow },
            info = { fg = colors.dragonBlue },
            hint = { fg = colors.dragonGreen },
          },
          colored = true,
          color = { bg = colors.bg },
          padding = { left = 3, right = 1 },
        },
      },
      lualine_x = {},
      lualine_y = {
        {
          'branch',
          icon = signs.git.branch,
          color = { fg = colors.dragonBlack2, bg = colors.dragonGreen },
          separator = { right = '', left = '' },
        },
        {
          'diff',
          colored = false,
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
          -- color = { bg = colors.bg },
          -- diff_color = {
          -- 	added = { gui = "bold" },
          -- 	modified = { gui = "bold" },
          -- 	removed = { gui = "bold" },
          -- },
        },
      },
      lualine_z = {},
    }

    local config = {
      options = {
        theme = lualine_theme,
        disabled_filetypes = { statusline = { 'alpha', 'dashboard' } },
        icons_enabled = true,
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
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
