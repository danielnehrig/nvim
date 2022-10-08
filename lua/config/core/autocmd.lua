local Func = require("config.utils")
local M = {}

function M.autocmds()
  local au_pack = vim.api.nvim_create_augroup("packer", { clear = true })
  local au_utils = vim.api.nvim_create_augroup("utils", { clear = true })
  local au_ft = vim.api.nvim_create_augroup("ft", { clear = true })
  local au_cmp = vim.api.nvim_create_augroup("cmp", { clear = true })
  local au_highlight =
    vim.api.nvim_create_augroup("highlight", { clear = true })

  -- hi
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    command = "highlight Pmenu guibg=none",
    group = au_highlight,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    command = "highlight FloatBorder guibg=none ctermbg=none",
    group = au_highlight,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    command = "highlight NormalFloat guifg=#fff guibg=none ctermbg=none",
    group = au_highlight,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    command = "highlight FoldColumn guifg=#a485dd guibg=none ctermbg=none",
    group = au_highlight,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    command = "highlight GitSignsChange ctermbg=none guibg=none",
    group = au_highlight,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    command = "highlight GitSignsDelete ctermbg=none guibg=none",
    group = au_highlight,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    command = "highlight GitSignsAdd ctermbg=none guibg=none",
    group = au_highlight,
  })

  -- util
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      Func.open_diag_float()
    end,
    group = au_utils,
  })
  vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
      require("config.plugins.configs.lspconfig.servers.lua").reinit()
    end,
    group = au_utils,
  })
  -- pack
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.lua",
    callback = function()
      -- require("config.core.global").reload_all()
    end,
    group = au_pack,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "PackerComplete",
    callback = function()
      require("packer").compile()
    end,
    group = au_pack,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "PackerCompileComplete",
    callback = function()
      vim.notify("Packer Compiled!")
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
  }, {
    pattern = "*.*",
    callback = function()
      vim.wo.number = true
      vim.wo.relativenumber = true
      vim.o.showtabline = 2
    end,
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
    pattern = "dashboard",
    callback = function()
      vim.wo.number = false
    end,
    group = au_ft,
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

  vim.api.nvim_create_autocmd("User", {
    pattern = "GitConflictDetected",
    callback = function()
      vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
    end,
  })

  vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = { "*:i*", "i*:*" },
    group = au_utils,
    callback = function()
      if vim.bo.filetype ~= "TelescopePrompt" then
        vim.o.relativenumber = vim.v.event.new_mode:match("^i") == nil
      end
    end,
  })
end

return M
