local globals = require("config.core.global")
local g, b, opt, go, wo = vim.g, vim.b, vim.opt, vim.go, vim.wo
local M = {}

function M.load_options()
  g.did_load_filetypes = 0
  g.do_filetype_lua = 1

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
  opt.shortmess:append("sI")

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

  opt.signcolumn = "auto:2" -- 2 sign column
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
  opt.lazyredraw = true

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
  opt.foldcolumn = "1"
  g.cursorhold_updatetime = 100

  -- scroller
  vim.g.scrollbar_shape = {
    head = "▎",
    body = "▎",
    tail = "▎",
  }

  local default_plugins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
  }

  for _, plugin in pairs(default_plugins) do
    g["loaded_" .. plugin] = 1
  end
end

M.fold_column_toggle = function()
  wo.foldcolumn = wo.foldcolumn == "0" and "auto:3" or "0"
end

M.relative_position_toggle = function()
  wo.relativenumber = not wo.relativenumber
  wo.number = not wo.relativenumber
end

M.number_toggle = function()
  wo.number = not wo.number
  wo.relativenumber = wo.number
end

M.spell_toggle = function()
  wo.spell = not wo.spell
end

return M
