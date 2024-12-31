---@class load_config
local M = {}
M.__index = M

-- this is loaded after bootstrapping the plugin manager
-- and or if package manager plugins are installed
-- load configs for package manager plugins
M.init = function()
  require("config.themes").load_theme()
  require("config.plugins.configs.web-devicons").init()
  require("config.plugins.configs.treesitter").init()
  require("config.plugins.configs.build").init()
  -- require("config.plugins.configs.bufferline").init()
end

return M
