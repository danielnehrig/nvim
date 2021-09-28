local M = {}
M.__index = M

-- this is loaded after bootstrapping packer
-- and or if packer plugins are installed
-- load configs for packer plugins
M.init = function()
  require("plugins.web-devicons")
  require("plugins.autopairs").init()
  require("plugins.nvimTree").init()
  require("plugins.treesitter").init()
  require("plugins.refactoring")
  require("plugins.wildmenu")
  require("plugins.build"):init()
  require("plugins.bufferline").init()

  -- load last to overwrite every highlight that has been added by a plugin
  require("core.highlights")
end

return M
