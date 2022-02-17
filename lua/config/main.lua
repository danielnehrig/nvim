-- Main Load File
-- Execution Flow of each loaded configuration
-- for various plugins
-- also a lot of configuration for plugins can be found
-- in the packer config setup
-- because of lazyloading
local g, opt = vim.g, vim.opt

-- disable plugins
local disabled_built_ins = {
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

g.did_load_filetypes = 1

-- check if we are in VSCode nvim
-- if not do not apply plugins
-- slows down VSCode and makes it non usable
if not g.vscode then
  -- setup conf and lua modules
  require("config.core.global")
  require("config.core.options").load_options()
  require("config.core.mappings").mappings()
  require("config.core.autocmd").autocmds()

  local pack = require("config.packer-config")
  pack.bootstrap()
  pack.load_compile()

  opt.shadafile = ""
end
