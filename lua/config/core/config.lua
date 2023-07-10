local create_config = function()
  local config = require("config.core.default_config")
  local custom_config = vim.fn.filereadable(
    vim.fn.stdpath("config") .. "/lua/config/custom/init.lua"
  ) == 1

  if custom_config then
    local user_config = require("config.custom")
    config = vim.tbl_deep_extend("force", config, user_config)
  end

  return config
end

local M = {
  config = create_config(),
}

M.remove_default_plugins = function(plugins)
  local removals = M.config.plugins.remove or {}

  if not vim.tbl_isempty(removals) then
    for _, plugin in pairs(removals) do
      plugins[plugin] = nil
    end
  end

  return plugins
end

return M
