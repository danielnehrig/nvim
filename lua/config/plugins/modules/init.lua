local git = require("config.plugins.modules.git").git
local utility = require("config.plugins.modules.utility").utility
local theme = require("config.plugins.modules.themes").theme
local ts_themes = require("config.plugins.modules.themes").ts_themes
local ts = require("config.plugins.modules.treesitter").ts
local lsp = require("config.plugins.modules.lsp").lsp
local completion = require("config.plugins.modules.completion").completion
local language = require("config.plugins.modules.language").language
local debug = require("config.plugins.modules.debug").debug
local packer = require("config.plugins.modules.navigation").packer

local M = {}

local plugin_table = {}
plugin_table = vim.tbl_deep_extend(
  "force",
  plugin_table,
  theme,
  git,
  utility,
  ts_themes,
  lsp,
  ts,
  completion,
  debug,
  packer,
  language
)

plugin_table =
  require("config.core.config").remove_default_plugins(plugin_table)
local user_plugins = require("config.core.config").get_config().plugins.user
plugin_table = vim.tbl_deep_extend("force", plugin_table, user_plugins)

M.plugins = {}

for key, _ in pairs(plugin_table) do
  plugin_table[key][1] = key

  M.plugins[#M.plugins + 1] = plugin_table[key]
end

return M
