local config = require("config.core.config").config
local M = {}
---@module 'config.themes.hl.types'

---@param type "base_30" | "base_16" | "polish_hl"
---@return BASE_30 | BASE_16
M.get_theme_tb = function(type)
  local default_path = "config.themes.hl." .. config.ui.colorscheme.name

  local present1, default_theme = pcall(require, default_path)

  if present1 then
    return default_theme[type]
  else
    error("No such theme! " .. default_path)
  end
end

M.get_colors = M.get_theme_tb

---@generic A:table
---@generic B:table
---@param table1 table<A>
---@param table2 table<B>
---@return table<A> | table<B>
M.merge_tb = function(table1, table2)
  return vim.tbl_deep_extend("force", table1, table2)
end

---@param highlights table<string, Highlight>
M.extend_default_hl = function(highlights)
  local polish_hl = M.get_theme_tb("polish_hl")

  -- polish themes
  if polish_hl then
    for key, value in pairs(polish_hl) do
      if highlights[key] then
        highlights[key] = M.merge_tb(highlights[key], value)
      end
    end
  end

  -- transparency
  if vim.g.transparency then
    local glassy = require("config.themes.glassy")

    for key, value in pairs(glassy) do
      if highlights[key] then
        highlights[key] = M.merge_tb(highlights[key], value)
      end
    end
  end

  if config.ui.hl_override then
    local overriden_hl = M.turn_str_to_color(config.ui.hl_override)

    for key, value in pairs(overriden_hl) do
      if highlights[key] then
        highlights[key] = M.merge_tb(highlights[key], value)
      end
    end
  end
end

--- turns color var names in hl_override/hl_add to actual colors
--- hl_add = { abc = { bg = "one_bg" }} -> bg = colors.one_bg
--- @param tb table<string, table<string, string>>
M.turn_str_to_color = function(tb)
  local colors = M.get_theme_tb("base_30")

  for _, hlgroups in pairs(tb) do
    for opt, val in pairs(hlgroups) do
      if
        (opt == "fg" or opt == "bg")
        and not (val:sub(1, 1) == "#" or val == "none" or val == "NONE")
      then
        hlgroups[opt] = colors[val]
      end
    end
  end

  return tb
end

---@param group string
M.load_highlight = function(group)
  group = require("config.themes.integrations." .. group)
  M.extend_default_hl(group)
  return group
end

---@param default_theme ColorScheme the colorscheme like radium includes all colors
---@param theme_name string then name of the colorscheme
M.override_theme = function(default_theme, theme_name)
  local changed_themes = config.ui.changed_themes

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

M.toggle_transparent = function()
  config.ui.transparent = not config.ui.transparent

  M.load_theme()
end

return M
