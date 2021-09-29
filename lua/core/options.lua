local cmd = vim.cmd
local g, b, opt, go, wo, o = vim.g, vim.b, vim.opt, vim.go, vim.wo, vim.o
local M = {}

function M.load_options()
  if g.neovide then
    g.neovide_cursor_vfx_mode = "railgun"
  end
  opt.shadafile = "NONE"
  -- activate line numbers
  -- TODO: make toggle for pair programming
  opt.number = true -- enable numbers
  opt.relativenumber = true -- enable numbers to be relative

  -- completion menu settings
  opt.completeopt = "menuone,noselect" -- completion behaviour
  opt.omnifunc = "v:lua.vim.lsp.omnifunc" -- completion omnifunc

  -- Set so that folders are index for find command
  opt.path = "**/*"
  opt.wildignore:append({
    "node_modules",
    ".git",
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
  go.termguicolors = true -- colors tmux settings
  go.t_Co = "256" -- colors tmux setting
  go.t_ut = "" -- colors tmux setting
  -- opt.background = "dark" -- dark
  opt.numberwidth = 2 -- width on number row

  opt.mouse = "a" -- mouse on don't use mouse

  opt.signcolumn = "auto" -- 2 sign column
  opt.cmdheight = 1 -- ex cmd height
  opt.guifont = "Fira Code Regular Nerd Font Complete:h12" -- set font
  opt.showcmd = false -- disable showcmd keys bottom right
  opt.showmode = false -- modes
  opt.autoread = true -- reload files changed other edit

  if g.neovide then
    cmd('let g:neovide_cursor_vfx_mode = "pixiedust"')
  end

  opt.updatetime = 300 -- update interval for gitsigns
  opt.inccommand = "nosplit"
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
  opt.expandtab = true
  opt.shiftwidth = 2

  -- spell
  -- opt.spelllang = "en,de"
  -- opt.spell = true

  -- fold settings
  wo.foldmethod = "expr"
  o.foldtext =
    [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
  wo.foldexpr = "nvim_treesitter#foldexpr()"
  wo.fillchars = "fold:\\"
  wo.foldnestmax = 3
  wo.foldminlines = 1

  -- scroller
  vim.g.scrollbar_shape = {
    head = "▎",
    body = "▎",
    tail = "▎",
  }
end

return M
