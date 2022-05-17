--- @type string HOME always exists
local home = os.getenv("HOME")
local path_sep = package.config:sub(1, 1)
--- @type string
local os_name = vim.loop.os_uname().sysname

local global = {}
global._index = global
function global:load_variables()
  self.is_darwin = os_name == "Darwin"
  self.is_linux = os_name == "Linux"
  self.is_windows = os_name == "Windows"
  self.os_name = os_name
  self.border_style = "rounded"
  self.sumenko_os = os_name == "Darwin" and "macOS" or "Linux"
  self.vim_path = vim.fn.stdpath("config")
  self.path_sep = path_sep
  self.home = home
  self.dap_path = vim.fn.stdpath("data") .. path_sep .. "dapinstall"
  self.lsp_path = vim.fn.stdpath("data") .. path_sep .. "lsp"
  self.data_path = string.format(
    "%s" .. path_sep .. "site" .. path_sep,
    vim.fn.stdpath("data")
  )
end

global:load_variables()

--- Reload the Config
function global.reload()
  for k, _ in pairs(package.loaded) do
    if string.match(k, "^config") then
      package.loaded[k] = nil
    end
  end
  vim.notify("Config Reload")
  vim.cmd("luafile " .. vim.env.MYVIMRC)
  vim.cmd("doautocmd VimEnter")
end

return global
