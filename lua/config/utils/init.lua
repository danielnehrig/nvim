local global = require("config.core.global")
local config = require("config.core.config").config
local themes = require("config.plugins.modules.themes").ts_themes

local M = {}

function M.toggle_qf()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd("cclose")
    return
  else
    vim.cmd("copen")
    return
  end
end

function M.open_diag_float()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      return
    end
  end
  vim.diagnostic.open_float({
    source = true,
    focusable = false,
    focus = false,
    border = global.border_style,
  })
end

--- Replaces / or \\ depending on os to path to correct places
--- @param str string
--- @return string
function M.build_path_string(str)
  local result = str
  local path_sep = package.config:sub(1, 1)
  result = result:gsub("/", path_sep)
  return result
end

--- combines plugin manager colorschemes
--- with internal colorschemes
--- @todo add support for custom colorschemes
--- @param arg string
M.switch_theme = function(arg)
  local colorscheme = nil

  -- local project themes
  local hl_dir = vim.fn.stdpath("config") .. "/lua/config/themes/hl"
  local hl_files = require("plenary.scandir").scan_dir(hl_dir, {})

  for _, file in ipairs(hl_files) do
    local a = vim.fn.fnamemodify(file, ":t")
    a = vim.fn.fnamemodify(a, ":r")
    if arg == a then
      colorscheme = a
    end
  end

  if colorscheme then
    require("config.core.config").config.ui.colorscheme.name = colorscheme
    require("config.themes").load_theme()

    require("plenary.reload").reload_module(
      "config.plugins.configs.statusline.theme." .. config.ui.statusline.name
    )
    require("config.plugins.configs.statusline.windline").switch_theme(
      config.ui.statusline.name
    )
    return
  end

  vim.notify(string.format("colorscheme %s not found", arg))
end

--- Returns a list of themes integrated and plugin colorschemes
--- @return string[]
M.get_themes = function()
  ---@type string[]
  local res = {}

  local hl_dir = vim.fn.stdpath("config") .. "/lua/config/themes/hl"
  local hl_files = require("plenary.scandir").scan_dir(hl_dir, {})

  for _, file in ipairs(hl_files) do
    local a = vim.fn.fnamemodify(file, ":t")
    a = vim.fn.fnamemodify(a, ":r")
    table.insert(res, a)
  end

  for theme_name, _ in pairs(themes) do
    table.insert(res, theme_name)
  end

  return res
end

return M
