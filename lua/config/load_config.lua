local config = require("config.core.config").config
local M = {}
M.__index = M

-- this is loaded after bootstrapping packer
-- and or if packer plugins are installed
-- load configs for packer plugins
M.init = function()
  require("config.themes").load_theme()
  require("config.plugins.configs.statusline.windline").switch_theme(
    config.ui.statusline.name
  )
  require("config.plugins.configs.web-devicons").init()
  require("config.plugins.configs.treesitter").init()
  require("config.plugins.configs.build").init()
  require("config.plugins.configs.bufferline").init()
end

return M
