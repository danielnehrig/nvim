--- @type string HOME always exists
local home = os.getenv("HOME")
local path_sep = package.config:sub(1, 1)
--- @type string
local os_name = vim.loop.os_uname().sysname

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
  dap_path = vim.fn.stdpath("data") .. path_sep .. "dapinstall",
  lsp_path = vim.fn.stdpath("data") .. path_sep .. "lsp",
  data_path = string.format(
    "%s" .. path_sep .. "site" .. path_sep,
    vim.fn.stdpath("data")
  ),
}

--- Reload the Config
function M.reload_all()
  for k, _ in pairs(package.loaded) do
    if string.match(k, "^config") then
      package.loaded[k] = nil
    end
  end
  vim.notify("Config Reload")
  vim.cmd("luafile " .. vim.env.MYVIMRC)
  vim.cmd("doautocmd VimEnter")
end

function M.reload(plugins)
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

return M
