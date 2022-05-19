-- Main Load File
-- Execution Flow of each loaded configuration
-- for various plugins
-- also a lot of configuration for plugins can be found
-- in the packer config setup
-- because of lazyloading
local g, opt = vim.g, vim.opt

-- check if we are in VSCode nvim
-- if not do not apply plugins
-- slows down VSCode and makes it non usable
if not g.vscode then
  -- setup conf and lua modules
  require("config.core.global")
  require("config.core.options").load_options()
  require("config.core.mappings").mappings()
  require("config.core.autocmd").autocmds()
  require("config.core.commands").init()

  local pack = require("config.plugins")
  pack.bootstrap()
  pack.load_compile()

  opt.shadafile = ""
end
