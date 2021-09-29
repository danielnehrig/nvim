local global = {}
local home = os.getenv("HOME")
-- local path_sep = global.is_windows and "\\" or "/"
local path_sep = package.config:sub(1, 1)
local os_name = vim.loop.os_uname().sysname

function global:load_variables()
  self.is_darwin = os_name == "Darwin"
  self.is_linux = os_name == "Linux"
  self.is_windows = os_name == "Windows"
  self.os_name = os_name
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

return global
