---@meta
---@class Ui
---@field changed_themes string[] a list of themes that have been changed
---@field logo string the dashboard logo (info the path your logo string will append to is the neovim config path)
---@field transparent boolean A toggle to make everything transparent
---@field colorscheme Colorscheme the colorscheme config
---@field statusline Statusline the statusline config
---@field hl_override table<string, Highlight> a table of highlights to override

---@class Colorscheme
---@field name ColorschemeNames the name of the colorscheme
--- the names of the colorschemes to toggle between (nice for light/dark themes)
---@field toggle ColorschemeNames[]

---@class Statusline
---@field name StatuslineThemes the name of the statusline theme
---@field seperator SeperatorStyle the name of the seperator style

---@class Plugins
---@field user table<string, LazyPluginSpec> plugins you want to add
---@field remove string[] plugins you want to remove from the default list see modules folder

---@class Config
---@field ui Ui the ui config
---@field plugins Plugins the plugin config
---@field mappings MapModes the mapping config

---@alias StatuslineThemes
---| '"slanted_lsp"'

---@alias SeperatorStyle
---| '"slant_right"'
---| '"slant_left"'
---| '"arrow_right"'
---| '"arrow_left"'

---@alias ColorschemeNames
---| '"github_dark_default"'
---| '"radium"'
---| '"onedark"'
