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
  package.path = package.path
    .. ";"
    .. vim.fn.expand("~/.local/share/nvim/plugin/?.lua")
  -- setup conf and lua modules
  require("config.core.options").load_options()
  local config = require("config.core.config").get_config()
  local pack = require("config.plugins")
  if config.ui.plugin_manager == "packer" then
    if
      vim.fn.filereadable(
      vim.fn.expand("~/.local/share/nvim/plugin/packer_compiled.lua")
    ) == 1
    then
      require("packer_compiled")
      pack.packer_bootstrap()
      pack.load_compile()
    end
  else
    pack.lazy_bootstrap()
  end
  require("config.core.mappings").mappings()
  require("config.core.autocmd").autocmds()
  require("config.core.commands").init()


  opt.shadafile = ""
else
  vim.g.did_load_filetypes = 0
  vim.g.do_filetype_lua = 1
  vim.opt.wildignore:append({
    "node_modules",
    ".git/",
    "dist",
    ".next",
    "target",
    "android",
    "ios",
    "coverage",
    "build",
  })
  vim.g.mapleader = " " -- space leader
  require("config.core.mappings").vscode_mappings()
end
