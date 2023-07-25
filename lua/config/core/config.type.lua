---@meta
---@class Ui
---@field changed_themes string[] a list of themes that have been changed
---@field transparent boolean A toggle to make everything transparent
---@field colorscheme Colorscheme the colorscheme config
---@field statusline Statusline the statusline config
---@field hl_override table<string, Highlight> a table of highlights to override

---@class Colorscheme
---@field name string the name of the colorscheme
---@field toggle table the names of the colorschemes to toggle between (nice for light/dark themes)

---@class Statusline
---@field name string the name of the statusline theme
---@field seperator string the name of the seperator style

---@class Plugins
---@field user table<string, LazyPluginSpec> plugins you want to add
---@field remove string[] plugins you want to remove from the default list

---@class Config
---@field ui Ui the ui config
---@field plugins Plugins the plugin config
