local cmd = vim.cmd
local g, b, opt, go = vim.g, vim.b, vim.opt, vim.go

local function load_options()
    opt.shadafile = "NONE"
    -- activate line numbers
    -- TODO: make toggle for pair programming
    opt.number = true -- enable numbers
    opt.relativenumber = true -- enable numbers to be relative

    -- completion menu settings
    opt.completeopt = "menuone,noselect" -- completion behaviour
    opt.omnifunc = "v:lua.vim.lsp.omnifunc" -- completion omnifunc

    -- Set so that folders are index for find command
    opt.path:append({"**/*"})
    opt.wildignore:append({"node_modules", ".git", "dist", ".next"})

    g.mapleader = " " -- space leader

    -- Tag Jump
    b.match_words = table.concat({"(:),\\[:\\],{:},<:>,", "<\\@<=\\([^/][^ \t>]*\\)[^>]*\\%(>\\|$\\):<\\@<=/\1>"})
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
    opt.guifont = "Hack Nerd Font Mono:h12" -- set font
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
    opt.fileformats = "unix,dos,mac"

    -- fast
    opt.ttyfast = true
    opt.lazyredraw = true

    -- for indentline
    -- indentation settings
    opt.expandtab = true
    opt.shiftwidth = 2

    -- spell
    opt.spelllang = "en"
    opt.spell = true
end

load_options()
