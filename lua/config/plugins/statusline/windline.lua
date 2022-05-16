local themes = {
  "slanted_lsp",
}

local M = {}

M.switch_theme = function(arg)
  require("config.plugins.statusline.theme." .. arg).theme.config()
end

M.get_themes = function()
  local res = {}
  for _, theme_tbl in ipairs(themes) do
    local theme = require("config.plugins.statusline.theme." .. theme_tbl).theme
    table.insert(res, theme.name)
  end
  return res
end

return M
