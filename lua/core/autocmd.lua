local Func = require("utils")
local M = {}

function M.autocmds()
  local definitions = {
    ft = {
      { "FileType", "NvimTree,lspsagafinder,dashboard", "let b:cusorword=0" },
      { "FileType", "dashboard", "set showtabline=0" }, -- disable tabline in dashboard
      { "BufNewFile,BufRead", "*", "set showtabline=2" }, -- renable it
      { "TermOpen", "*", "set nonumber" },
      { "TermOpen", "*", "set norelativenumber" },
      { "TermOpen", "*", "set showtabline=0" }, -- renable it
      { "BufNewFile,BufRead", "*.toml", " setf toml" }, -- set toml filetype
      {
        "FileType",
        "*.toml",
        "lua require('cmp').setup.buffer { sources = { { name = 'crates' } } }",
      },
    },
    ScrollbarInit = {
      {
        "CursorMoved,VimResized,QuitPre",
        "*",
        "silent! lua require('scrollbar').show()",
      },
      {
        "WinEnter,FocusGained",
        "*",
        "silent! lua require('scrollbar').show()",
      },
      {
        "WinLeave,BufLeave,BufWinLeave,FocusLost",
        "*",
        "silent! lua require('scrollbar').clear()",
      },
    },
  }

  Func.nvim_create_augroups(definitions)
end

return M
