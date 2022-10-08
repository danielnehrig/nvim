local use_config = require("config.core.config").get_config
local M = {}

M.get_colors = function(type)
  local name = use_config().ui.colorscheme.name

  -- theme paths
  local user_path = "config.themes.hl." .. name

  local present2, user_theme = pcall(require, user_path)

  if present2 then
    return user_theme[type]
  else
    error("No such theme")
  end
end

M.override_theme = function(default_theme, theme_name)
  local changed_themes = use_config().ui.changed_themes

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
  local highlights_raw =
    vim.split(vim.api.nvim_exec("filter BufferLine hi", true), "\n")
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

M.toggle_theme = function()
  local themes = use_config().ui.colorscheme.toggle

  local theme1 = themes[1]
  local theme2 = themes[2]

  if vim.g.toggle_theme_icon == "   " then
    vim.g.toggle_theme_icon = "   "
  else
    vim.g.toggle_theme_icon = "   "
  end

  if use_config().ui.colorscheme.name == theme1 then
    require("config.core.config").config.ui.colorscheme.name = theme2

    M.load_theme()
    -- change_theme(theme1, theme2)
  elseif use_config().ui.colorscheme.name == theme2 then
    require("config.core.config").config.ui.colorscheme.name = theme1

    M.load_theme()
    -- change_theme(theme2, theme1)
  else
    vim.notify(
      "Set your current theme to one of those mentioned in the theme_toggle table (chadrc)"
    )
  end
end

M.toggle_transparent = function()
  require("config.core.config").config.ui.transparent =
    not use_config().ui.transparent

  M.load_theme()
end

return M
