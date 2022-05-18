local M = {}
M.__index = M

-- this is loaded after bootstrapping packer
-- and or if packer plugins are installed
-- load configs for packer plugins
M.init = function()
  local present, impatient = pcall(require, "impatient")
  if not present then
    vim.notify(string.format("impatient not installed"))
    return
  end
  impatient.enable_profile()
  local global = require("config.core.global")
  require("config.themes").load_theme()
  require("config.plugins.configs.statusline.windline").switch_theme(
    global.config.ui.statusline.name
  )
  require("config.plugins.configs.web-devicons").init()
  require("config.plugins.configs.autopairs").init()
  require("config.plugins.configs.treesitter").init()
  require("config.plugins.configs.build").init()
  require("config.plugins.configs.bufferline").init()

  -- load last to overwrite every highlight that has been added by a plugin
  -- require("config.core.highlights")
end

return M
