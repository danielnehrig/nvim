local Func = require("config.utils")
local M = {}

function M.autocmds()
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      Func.open_diag_float()
    end,
  })
  local definitions = {
    packer = {
      {
        "BufWritePost",
        "*.lua",
        "lua require('config.core.global').reload()",
      },
      {
        "User",
        "PackerCompileDone",
        "lua require('config.core.global').reload()",
      },
      {
        "User",
        "PackerComplete",
        "lua require('config.packer-config').auto_compile()",
      },
    },
    ft = {
      {
        "FileType",
        "markdown,org,txt,tex",
        "lua vim.wo.spell = true",
      },
      { "FileType", "NvimTree,lspsagafinder,dashboard", "let b:cusorword=0" },
      {
        "WinEnter,BufRead,BufEnter",
        "dashboard",
        "Dashboard",
      }, -- disable tabline in dashboard
      { "BufNewFile,BufRead", "*.toml", "setf toml" }, -- set toml filetype
      {
        "FileType",
        "*.toml",
        "lua require('cmp').setup.buffer { sources = { { name = 'crates' } } }",
      },
      {
        "FileType",
        "*.org",
        "lua require('cmp').setup.buffer { sources = { { name = 'orgmode' } } }",
      },
    },
    Terminal = {
      { "TermOpen", "*", "set nonumber" },
      { "TermOpen", "*", "set norelativenumber" },
      { "TermOpen", "*", "set showtabline=0" }, -- renable it
      { "WinEnter,BufEnter", "terminal", "set nonumber" },
      { "WinEnter,BufEnter", "terminal", "set norelativenumber" },
      { "WinEnter,BufEnter", "terminal", "set showtabline=0" }, -- renable it
    },
    TabLine = {
      { "FileType", "dashboard,TelescopePrompt,prompt", "set showtabline=0" }, -- disable tabline in dashboard
      {
        "WinLeave,WinClosed,BufLeave,BufDelete,BufUnload,BufWinLeave,BufWipeout",
        "TelescopePrompt,prompt",
        "set showtabline=2",
      }, -- disable tabline in dashboard
      {
        "BufNewFile,BufRead,WinEnter,TermLeave",
        "*.*",
        "set showtabline=2",
      }, -- renable it
    },
    lsp = {
      {
        "DirChanged",
        "*",
        'silent! lua require("plugins.lspconfig.lua").reinit()',
      },
    },
  }

  Func.nvim_create_augroups(definitions)
end

return M
