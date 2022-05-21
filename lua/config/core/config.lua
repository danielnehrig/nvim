local M = {
  config = nil,
}

-- overrides config plugins
M.load_override = function(default_table, plugin_name)
  local user_table = M.get_config().plugins.override[plugin_name]

  if type(user_table) == "table" then
    default_table = vim.tbl_deep_extend("force", default_table, user_table)
  else
    default_table = default_table
  end

  return default_table
end

-- merges default and user config
M.get_config = function()
  if M.config then
    return M.config
  end

  local config = require("config.core.default_config")
  local custom_config = vim.fn.filereadable(
    vim.fn.stdpath("config") .. "/lua/config/custom/init.lua"
  ) == 1

  if custom_config then
    local user_config = require("config.custom")
    config = vim.tbl_deep_extend("force", config, user_config)
  end

  M.config = config
  return config
end

M.remove_default_plugins = function(plugins)
  local removals = M.get_config().plugins.remove or {}

  if not vim.tbl_isempty(removals) then
    for _, plugin in pairs(removals) do
      plugins[plugin] = nil
    end
  end

  return plugins
end

return M
