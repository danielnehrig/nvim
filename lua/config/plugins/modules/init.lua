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

-- Aims to remove plugin keys not used by lazy
local function packer_key_filter()
  local delete_list = { "requires", "after", "wants" }
  if M.plugins == nil then
    error("plugins is nil")
  end
  -- remove every key in the table based on delete list
  for _, plugin in pairs(M.plugins) do
    for _, key in pairs(delete_list) do
      plugin[key] = nil
    end
  end
end

-- Aims to remove plugin keys not used by packer
local function lazy_key_filter()
  local delete_list = { "dependencies" }
  local delete_list_event = { "VeryLazy" }
  if M.plugins == nil then
    error("plugins is nil")
  end
  -- remove every key in the table based on delete list
  for _, plugin in pairs(M.plugins) do
    for _, key in pairs(delete_list) do
      plugin[key] = nil
    end
    for _, key in pairs(delete_list_event) do
      plugin["event"] = nil
    end
  end
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

  --  plugin_table =
  --  require("config.core.config").remove_default_plugins(plugin_table)
  local user_plugins = require("config.core.config").config.plugins.user
  plugin_table = vim.tbl_deep_extend("force", plugin_table, user_plugins)

  local plugins = {}
  for key, _ in pairs(plugin_table) do
    plugin_table[key][1] = key

    plugins[#plugins + 1] = plugin_table[key]
  end
  return plugins
end

local M = {
  plugins = create_plugins(),
}

return M
