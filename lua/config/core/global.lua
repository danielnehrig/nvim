--- @type string HOME always exists
local home = os.getenv("HOME") --[[@as string]]

local path_sep = package.config:sub(1, 1)
--- @type string
local os_name = vim.loop.os_uname().sysname

---@class Global
local M = {
  is_darwin = os_name == "Darwin",
  is_linux = os_name == "Linux",
  is_windows = os_name == "Windows",
  os_name = os_name,
  border_style = "rounded",
  sumenko_os = os_name == "Darwin" and "macOS" or "Linux",
  vim_path = vim.fn.stdpath("config"),
  path_sep = path_sep,
  home = home,
  dap_path = vim.fn.stdpath("data") .. path_sep .. "mason" .. path_sep .. "bin",
  lsp_path = vim.fn.stdpath("data") .. path_sep .. "lsp",
  data_path = string.format(
    "%s" .. path_sep .. "site" .. path_sep,
    vim.fn.stdpath("data")
  ),
}

return M
