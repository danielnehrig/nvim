---@meta
---@class Ui
---@field changed_themes type<ColorschemeNames, ColorScheme> a list of themes that have been changed
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
---the name of the seperator styles left and right side length = 2
---@field separator SeperatorStyle[]

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
---| '"vertical_bar"'
---| '"vertical_bar_thin"'
---| '"left"'
---| '"right"'
---| '"block"'
---| '"block_thin"'
---| '"left_filled"'
---| '"right_filled"'
---| '"slant_left"'
---| '"slant_left_thin"'
---| '"slant_right"'
---| '"slant_right_thin"'
---| '"slant_left_2"'
---| '"slant_left_2_thin"'
---| '"slant_right_2"'
---| '"slant_right_2_thin"'
---| '"left_rounded"'
---| '"left_rounded_thin"'
---| '"right_rounded"'
---| '"right_rounded_thin"'
---| '"circle"'
---| '"none"'

---@alias ColorschemeNames
---| '"github_dark_default"'
---| '"radium"'
---| '"onedark"'
---| '"github_light"'
---| '"gruvchad"'
---| '"onenord_dark"'
---| '"tokyonight"'
---| '"tokyodark"'
---| '"vscode_dark"'
