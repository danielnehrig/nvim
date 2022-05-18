local async = require("plenary.async")
local themes = require("config.packer-config.modules.themes").ts_themes
local global = require("config.core.global")
local M = {}

M.packer_sync = function()
  async.run(function()
    vim.notify.async("Syncing packer.", "info", {
      title = "Packer",
    })
  end)
  local snap_shot_time = os.date("!%Y-%m-%dT%TZ")
  vim.cmd("PackerSnapshot " .. snap_shot_time)
  vim.cmd("PackerSync")
end

M.switch_theme = function(arg)
  local colorscheme = nil
  local packadd = nil

  -- packer themes
  for theme_name, theme in pairs(themes) do
    if arg == theme_name then
      colorscheme = theme.colorscheme
      packadd = theme.packadd
    end
  end

  if colorscheme then
    local packadd_ok, _ = pcall(vim.cmd, string.format("packadd %s", packadd))
    if not packadd_ok then
      return
    end

    local colorscheme_ok, _ = pcall(
      vim.cmd,
      string.format("colorscheme %s", colorscheme)
    )

    if not colorscheme_ok then
      vim.notify(string.format("colorscheme %s not found", colorscheme))
      return
    end

    return
  end

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
    global.config.ui.colorscheme.name = colorscheme
    require("config.themes").load_theme()
    return
  end

  vim.notify(string.format("colorscheme %s not found", arg))
end

M.get_themes = function()
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
