local M = {}
M.__index = M

-- this is loaded after bootstrapping packer
-- and or if packer plugins are installed
-- load configs for packer plugins
M.init = function()
  require("impatient").enable_profile()
  require("config.packer-config.funcs").switch_theme("tokyonight")
  require("config.plugins.statusline.theme.slanted_lsp").theme.config()
  require("config.plugins.web-devicons").init()
  require("config.plugins.autopairs").init()
  require("config.plugins.treesitter").init()
  require("config.plugins.build"):init()
  require("config.plugins.bufferline").init()

  -- load last to overwrite every highlight that has been added by a plugin
  require("config.core.highlights")
end

return M
