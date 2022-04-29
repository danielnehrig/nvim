local Func = require("config.utils")
local M = {}

function M.autocmds()
  local au_pack = vim.api.nvim_create_augroup("packer", { clear = true })
  local au_utils = vim.api.nvim_create_augroup("utils", { clear = true })
  local au_ft = vim.api.nvim_create_augroup("ft", { clear = true })
  local au_cmp = vim.api.nvim_create_augroup("cmp", { clear = true })

  -- util
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      Func.open_diag_float()
    end,
    group = au_utils,
  })
  vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
      require("plugins.lspconfig.lua").reinit()
    end,
    group = au_utils,
  })
  -- pack
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.lua",
    callback = function()
      require("config.core.global").reload()
    end,
    group = au_pack,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "PackerCompileDone",
    callback = function()
      require("config.packer-config").auto_compile()
      require("config.core.global").reload()
    end,
    group = au_pack,
  })
  -- ft
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown,org,txt,tex",
    callback = function()
      vim.wo.spell = true
    end,
    group = au_ft,
  })
  vim.api.nvim_create_autocmd({ "WinEnter", "BufRead", "BufEnter" }, {
    pattern = "dashboard",
    command = "Dashboard",
    group = au_ft,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "dashboard",
    command = "set showtabline=0",
    group = au_ft,
  })
  vim.api.nvim_create_autocmd({
    "BufNewFile",
    "BufRead",
    "WinEnter",
    "TermLeave",
  }, {
    pattern = "*.*",
    command = "set showtabline=2",
    group = au_ft,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "NvimTree,lspsagafinder,dashboard",
    callback = function()
      -- vim.opt.cursor_word = 0
    end,
    group = au_ft,
  })
  -- cmp
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*.toml",
    callback = function()
      require("cmp").setup.buffer({ sources = { { name = "crates" } } })
    end,
    group = au_cmp,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*.org",
    callback = function()
      require("cmp").setup.buffer({ sources = { { name = "orgmode" } } })
    end,
    group = au_cmp,
  })
  -- util
  vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
      vim.highlight.on_yank()
    end,
    desc = "Highlight yank",
    group = au_utils,
  })
end

return M
