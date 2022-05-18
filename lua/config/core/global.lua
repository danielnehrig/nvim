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

--- Reload the Config
function global.reload_all()
  for k, _ in pairs(package.loaded) do
    if string.match(k, "^config") then
      package.loaded[k] = nil
    end
  end
  global:create_config()
  vim.notify("Config Reload")
  vim.cmd("luafile " .. vim.env.MYVIMRC)
  vim.cmd("doautocmd VimEnter")
end

function global.reload(plugins)
  local status = true
  local function _reload_plugin(plugin)
    local loaded = package.loaded[plugin]
    if loaded then
      package.loaded[plugin] = nil
    end
    local ok, err = pcall(require, plugin)
    if not ok then
      print("Error: Cannot load " .. plugin .. " plugin!\n" .. err .. "\n")
      status = false
    end
  end

  if type(plugins) == "string" then
    _reload_plugin(plugins)
    vim.notify(string.format("Plugin %s reloaded", plugins))
  elseif type(plugins) == "table" then
    for _, plugin in ipairs(plugins) do
      _reload_plugin(plugin)
      vim.notify(string.format("Plugins %s reloaded", unpack(plugins)))
    end
  end

  return status
end

-- merges default and user config
function global:create_config()
  self.config = require("config.core.default_config")
  local custom_config = vim.fn.filereadable(
    vim.fn.stdpath("config") .. "/lua/config/custom/init.lua"
  ) == 1

  if custom_config then
    local user_config = require("config.custom")
    self.config = vim.tbl_deep_extend("force", self.config, user_config)
  end
end

local global_instance = nil
if not global_instance then
  global_instance = global
  global_instance:load_variables()
  global_instance:create_config()
end

return global_instance
