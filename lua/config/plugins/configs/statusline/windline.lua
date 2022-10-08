local themes = {
  "slanted_lsp",
}

local M = {}

M.switch_theme = function(arg)
  local present, _ = pcall(require, "windline")
  if not present then
    vim.notify(string.format("windline not installed"))
    return
  end
  require("config.plugins.configs.statusline.theme." .. arg).theme.config()
end

M.get_themes = function()
  local res = {}
  for _, theme_tbl in ipairs(themes) do
    local theme =
      require("config.plugins.configs.statusline.theme." .. theme_tbl).theme
    table.insert(res, theme.name)
  end
  return res
end

return M
