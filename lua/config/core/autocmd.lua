local Func = require("config.utils")
local M = {}

function _G.javascript_indent()
  local line = vim.fn.getline(vim.v.lnum)
  local prev_line = vim.fn.getline(vim.v.lnum - 1)
  if line:match("^%s*[%*/]%s*") then
    if prev_line:match("^%s*%*%s*") then
      return vim.fn.indent(vim.v.lnum - 1)
    end
    if prev_line:match("^%s*/%*%*%s*$") then
      return vim.fn.indent(vim.v.lnum - 1) + 1
    end
  end

  return vim.fn["GetJavascriptIndent"]()
end

function M.autocmds()
  vim.cmd(
    [[autocmd FileType javascript setlocal indentexpr=v:lua.javascript_indent()]]
  )
  vim.cmd(
    [[autocmd FileType javascriptreact setlocal indentexpr=v:lua.javascript_indent()]]
  )
  vim.cmd(
    [[autocmd FileType typescript setlocal indentexpr=v:lua.javascript_indent()]]
  )
  vim.cmd(
    [[autocmd FileType typescriptreact setlocal indentexpr=v:lua.javascript_indent()]]
  )
  local definitions = {
    ft = {
      {
        "FileType",
        "markdown,org,txt,tex",
        "lua vim.wo.spell = true",
      },
      {
        "CursorHold",
        "*",
        "lua vim.diagnostic.open_float({focusable = false, focus = false, border = 'single' })",
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
    --  ScrollbarInit = {
    --  {
    --  "CursorMoved,VimResized,QuitPre",
    --  "*",
    --  "silent! lua require('scrollbar').show()",
    --  },
    --  {
    --  "WinEnter,FocusGained",
    --  "*",
    --  "silent! lua require('scrollbar').show()",
    --  },
    --  {
    --  "WinLeave,BufLeave,BufWinLeave,FocusLost",
    --  "*",
    --  "silent! lua require('scrollbar').clear()",
    --  },
    --  },
    lsp = {
      {
        "DirChanged",
        "*",
        'silent! lua require("plugins.lspconfig.lua").reinit()',
      },
    },

    --  gh = {
    --  { "DirChanged", "*", "silent! lua require('plugins.gh').load()" },
    --  },
  }

  Func.nvim_create_augroups(definitions)
end

return M
