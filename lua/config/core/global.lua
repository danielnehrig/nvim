local path_sep = package.config:sub(1, 1)

--- @type string
local os_name = vim.loop.os_uname().sysname

local home = function()
  if os_name == "Windows" or os_name == "Windows_NT" then
    return os.getenv("USERPROFILE") --[[@as string]]
  end

    return os.getenv("HOME") --[[@as string]]
end

---@class Global
---@field is_darwin boolean
---@field is_linux boolean
---@field is_windows boolean
---@field os_name string
---@field border_style string
---@field sumenko_os string
---@field vim_path string|string[]
---@field path_sep string
---@field home string
---@field dap_path string
---@field lsp_path string
---@field data_path string
local M = {
  is_darwin = os_name == "Darwin",
  is_linux = os_name == "Linux",
  is_windows = os_name == "Windows" or os_name == "Windows_NT",
  os_name = os_name,
  border_style = "rounded",
  sumenko_os = os_name == "Darwin" and "macOS" or "Linux",
  vim_path = vim.fn.stdpath("config"),
  path_sep = path_sep,
  home = home(),
  dap_path = vim.fn.stdpath("data") .. path_sep .. "mason" .. path_sep .. "bin",
  lsp_path = vim.fn.stdpath("data") .. path_sep .. "lsp",
  data_path = string.format(
    "%s" .. path_sep .. "site" .. path_sep,
    vim.fn.stdpath("data")
  ),
}

return M
