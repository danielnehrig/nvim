local globals = require("config.core.global")
local g, b, opt, go, wo = vim.g, vim.b, vim.opt, vim.go, vim.wo
local M = {}

if _G.StatusColumn then
  return
end

_G.StatusColumn = {
  handler = {
    fold = function()
      local lnum = vim.fn.getmousepos().line

      -- Only lines with a mark should be clickable
      if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
        return
      end

      local state
      if vim.fn.foldclosed(lnum) == -1 then
        state = "close"
      else
        state = "open"
      end

      vim.cmd.execute("'" .. lnum .. "fold" .. state .. "'")
    end,
  },

  display = {
    line = function()
      local lnum = tostring(vim.v.lnum)

      if vim.bo.filetype == "alpha" then
        return ""
      end

      if vim.v.wrap then
        return " " .. string.rep(" ", #lnum)
      end

      if #lnum == 1 then
        return " " .. lnum
      else
        return lnum
      end
    end,

    fold = function()
      if vim.v.wrap then
        return ""
      end

      if vim.bo.filetype == "alpha" then
        return ""
      end

      local lnum = vim.v.lnum
      local icon = " "

      -- Line isn't in folding range
      if vim.fn.foldlevel(lnum) <= 0 then
        return icon
      end

      -- Not the first line of folding range
      if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
        return icon
      end

      if vim.fn.foldclosed(lnum) == -1 then
        icon = ""
      else
        icon = ""
      end

      return icon
    end,
  },

  sections = {
    line_number = {
      [[%=%{v:lua.StatusColumn.display.line()}]],
    },
    spacing = {
      [[ ]],
    },
    sign_column = {
      [[%s]],
    },
    folds = {
      [[%#FoldColumn#]], -- HL
      [[%@v:lua.StatusColumn.handler.fold@]],
      [[%{v:lua.StatusColumn.display.fold()}]],
    },
    border = {
      [[%#StatusColumnBorder#]], -- HL
      [[▐]],
    },
    padding = {
      [[%#StatusColumnBuffer#]], -- HL
      [[ ]],
    },
  },

  build = function(tbl)
    local statuscolumn = {}

    for _, value in ipairs(tbl) do
      if type(value) == "string" then
        table.insert(statuscolumn, value)
      elseif type(value) == "table" then
        table.insert(statuscolumn, _G.StatusColumn.build(value))
      end
    end

    return table.concat(statuscolumn)
  end,

  set_window = function(value)
    vim.defer_fn(function()
      vim.api.nvim_win_set_option(
        vim.api.nvim_get_current_win(),
        "statuscolumn",
        value
      )
    end, 1)
  end,
}

--- load the options to configure the editors build in settings
function M.load_options()
  g.copilot_no_tab_map = true
  g.copilot_enabled = true
  opt.number = true -- enable numbers
  opt.relativenumber = true -- enable numbers to be relative
  -- opt.backupcopy = "auto" -- fix for when files are not detected changed

  -- completion menu settings
  opt.completeopt = "menu,menuone,noselect,noinsert" -- completion behaviour
  opt.omnifunc = "v:lua.vim.lsp.omnifunc" -- completion omnifunc
  opt.list = false
  opt.listchars:append("eol:↴")
  opt.laststatus = 3
  opt.cursorline = true
  opt.confirm = true
  opt.title = true
  opt.virtualedit = "NONE"
  opt.shortmess:append("sI")
  g.tex_flavor = "tex"

  -- Set so that folders are index for find command
  opt.path = "**/*"
  opt.wildignore:append({
    "node_modules",
    ".git/",
    "dist",
    ".next",
    "target",
    "android",
    "ios",
    "coverage",
    "build",
  })

  g.mapleader = " " -- space leader

  -- Tag Jump
  b.match_words = table.concat({
    "(:),\\[:\\],{:},<:>,",
    "<\\@<=\\([^/][^ \t>]*\\)[^>]*\\%(>\\|$\\):<\\@<=/\1>",
  })
  opt.matchpairs:append("<:>")

  opt.hidden = true -- buffer hidden
  opt.ignorecase = true -- case sens ignore search
  opt.splitbelow = true -- split behavior
  opt.splitright = true -- split behavior
  opt.termguicolors = true -- colors tmux settings
  go.t_Co = "256" -- colors tmux setting
  go.t_ut = "" -- colors tmux setting
  -- opt.background = "dark" -- dark
  opt.numberwidth = 2 -- width on number row

  opt.mouse = "a" -- mouse on don't use mouse

  opt.signcolumn = "auto" -- 2 sign column
  opt.cmdheight = 0 -- ex cmd height
  if globals.is_darwin then
    vim.o.guifont = "FiraCode Nerd Font Mono:h16" -- set font
  else
    vim.o.guifont = "FiraCode Nerd Font Mono:h12" -- set font
  end
  opt.showcmd = false -- disable showcmd keys bottom right
  opt.showmode = false -- modes
  opt.autoread = true -- reload files changed other edit

  if g.neovide then
    vim.g.neovide_cursor_vfx_mode = "pixiedust"
    vim.g.neovide_cursor_vfx_particle_lifetime = 1.6
    vim.g.neovide_cursor_vfx_particle_density = 30
    vim.g.neovide_cursor_vfx_particle_speed = 30.0
    vim.g.neovide_cursor_vfx_opacity = 500
    -- vim.g.neovide_transparency = 0.5
  end

  opt.updatetime = 60 -- update interval for gitsigns
  opt.inccommand = "nosplit"
  opt.incsearch = true
  opt.timeoutlen = 500
  opt.clipboard = "unnamedplus" -- clipboard yank
  opt.wildmenu = true
  opt.wildmode = "longest,full"
  opt.fileformats = "unix,dos,mac"

  -- fast
  opt.ttyfast = true
  opt.lazyredraw = false

  -- for indentline
  -- indentation settings
  opt.shiftwidth = 2
  opt.expandtab = true
  opt.smartindent = true

  -- spell
  opt.spelllang = "en,de"
  opt.spell = false

  opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  wo.foldnestmax = 3
  wo.foldlevel = 4
  opt.foldcolumn = "0"
  g.cursorhold_updatetime = 100

  -- scroller
  vim.g.scrollbar_shape = {
    head = "▎",
    body = "▎",
    tail = "▎",
  }

  vim.opt.statuscolumn = _G.StatusColumn.build({
    _G.StatusColumn.sections.line_number,
    _G.StatusColumn.sections.sign_column,
    _G.StatusColumn.sections.folds,
    _G.StatusColumn.sections.spacing,
  })
end

--- toggle the fold column
M.fold_column_toggle = function()
  wo.foldcolumn = wo.foldcolumn == "0" and "auto:3" or "0"
end

--- toggle the relative number from relative to absolute
M.relative_position_toggle = function()
  wo.relativenumber = not wo.relativenumber
  wo.number = not wo.relativenumber
end

--- toggle the number from relative to absolute
M.number_toggle = function()
  wo.number = not wo.number
  wo.relativenumber = wo.number
end

--- toggle the spell check
M.spell_toggle = function()
  wo.spell = not wo.spell
end

return M
