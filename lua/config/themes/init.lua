local global = require("config.core.global")
local M = {}

M.get_colors = function(type)
  local name = global.config.ui.colorscheme.name

  -- theme paths
  local user_path = "config.themes.hl." .. name

  local present2, user_theme = pcall(require, user_path)

  if present2 then
    return user_theme[type]
  else
    error("No such theme bruh >_< ")
  end
end

M.override_theme = function(default_theme, theme_name)
  local changed_themes = global.config.ui.changed_themes

  if changed_themes[theme_name] then
    return vim.tbl_deep_extend(
      "force",
      default_theme,
      changed_themes[theme_name]
    )
  else
    return default_theme
  end
end

M.load_theme = function()
  -- clear highlights of bufferline (cuz of dynamic devicons hl group on the buffer)
  local highlights_raw = vim.split(
    vim.api.nvim_exec("filter BufferLine hi", true),
    "\n"
  )
  local highlight_groups = {}

  for _, raw_hi in ipairs(highlights_raw) do
    table.insert(highlight_groups, string.match(raw_hi, "BufferLine%a+"))
  end

  for _, highlight in ipairs(highlight_groups) do
    vim.cmd([[hi clear ]] .. highlight)
  end
  -- above highlights clear code by https://github.com/max397574

  -- reload highlights for theme switcher
  require("plenary.reload").reload_module("config.themes.integrations")
  require("plenary.reload").reload_module("config.themes.theme_setup")

  require("config.themes.theme_setup")
end

return M
