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
---@module 'config.plugins.modules.types'

--- @param plugins PluginInterfaceMerged[]
--- @return PluginInterfaceLazy[]
--- Aims to remove table keys not used by lazy
local function packer_key_filter(plugins)
  local delete_list = {
    "requires",
    "after",
    "wants",
    "opt",
    "packadd",
    "colorscheme",
    "run",
    "setup",
  }
  for _, plugin in pairs(plugins) do
    for key, _ in pairs(plugin) do
      for _, delete_key in pairs(delete_list) do
        if delete_key == key then
          plugin[key] = nil
        end
      end
    end
  end
  return plugins
end

local function create_plugins()
  local plugin_table = vim.tbl_deep_extend(
    "force",
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

  local config = require("config.core.config").config
  local user_plugins = config.plugins.user
  plugin_table = vim.tbl_deep_extend("force", plugin_table, user_plugins)

  --- @type PluginInterfaceMerged[]
  local plugins = {}
  for key, _ in pairs(plugin_table) do
    plugin_table[key][1] = key

    plugins[#plugins + 1] = plugin_table[key]
  end

  if config.ui.plugin_manager == "lazy" then
    plugins = packer_key_filter(plugins)
  end

  return plugins
end

local M = {
  plugins = create_plugins(),
}

return M
