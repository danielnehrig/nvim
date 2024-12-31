local globals = require("config.core.global")
local g, opt, wo, o = vim.g, vim.opt, vim.go, vim.wo
local M = {}

--- Toggle fold on click
function _G.click_fold()
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
end

--- Toggle breakpoint on click
function _G.click_num()
  local lnum_cursor = vim.fn.getmousepos().line
  local lnum_pos = vim.fn.getpos(".")[2]

  vim.fn.setpos(".", { 0, lnum_cursor, 0, 0 })
  require("config.plugins.configs.dap.attach").init()
  require("dap").toggle_breakpoint()
  vim.fn.setpos(".", { 0, lnum_pos, 0, 0 })
end

M.StatusColumn = {
  blacklist_ft = { "alpha", "NvimTree", "OverseerForm" },
  blacklist_bt = { "terminal", "acwrite" },

  display = {
    line = function()
      for _, filetype in ipairs(M.StatusColumn.blacklist_ft) do
        if vim.bo.filetype == filetype then
          return ""
        end
      end

      for _, buftype in ipairs(M.StatusColumn.blacklist_bt) do
        if vim.bo.buftype == buftype then
          return ""
        end
      end

      if not vim.wo.number then
        return ""
      end

      local lnum = tostring(vim.v.relnum)

      if not vim.wo.relativenumber then
        lnum = tostring(vim.v.lnum)
      end

      if lnum == "0" then
        return tostring(vim.v.lnum)
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

      if not g.status_col_fold then
        return ""
      end

      for _, filetype in ipairs(M.StatusColumn.blacklist_ft) do
        if vim.bo.filetype == filetype then
          return ""
        end
      end

      for _, buftype in ipairs(M.StatusColumn.blacklist_bt) do
        if vim.bo.buftype == buftype then
          return ""
        end
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
      [[%@v:lua.click_num@]],
      [[%=%{v:lua.require('config.core.options').StatusColumn.display.line()}]],
    },
    spacing = {
      [[ ]],
    },
    sign_column = {
      [[%s]],
    },
    folds = {
      [[%#FoldColumn#]], -- HL
      [[%@v:lua.click_fold@]],
      [[%{v:lua.require('config.core.options').StatusColumn.display.fold()}]],
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
        table.insert(statuscolumn, M.StatusColumn.build(value))
      end
    end

    return table.concat(statuscolumn)
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
  g.autoformat = true

  opt.hidden = true -- buffer hidden
  opt.ignorecase = true -- case sens ignore search
  opt.splitbelow = true -- split behavior
  opt.splitright = true -- split behavior
  opt.termguicolors = true -- colors tmux settings
  -- opt.background = "dark" -- dark
  opt.numberwidth = 2 -- width on number row

  opt.mouse = "a" -- mouse on don't use mouse

  opt.signcolumn = "yes:1" -- 2 sign column
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

  o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  wo.foldnestmax = 3
  wo.foldlevel = 4
  opt.foldcolumn = "0"
  g.cursorhold_updatetime = 100
  g.loaded_ruby_provider = 0
  g.loaded_perl_provider = 0
  g.status_col_fold = true

  vim.opt.statuscolumn = M.StatusColumn.build({
    M.StatusColumn.sections.line_number,
    M.StatusColumn.sections.sign_column,
    M.StatusColumn.sections.folds,
    M.StatusColumn.sections.spacing,
  })
end

--- toggle the fold column
M.fold_column_toggle = function()
  g.status_col_fold = not g.status_col_fold
end

--- toggle the relative number from relative to absolute
M.relative_position_toggle = function()
  wo.relativenumber = not wo.relativenumber
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

--- toggle the sign column
M.toggle_signcolumn = function()
  o.signcolumn = o.signcolumn == "yes:1" and "no" or "yes:1"
end

return M
