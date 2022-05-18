local async = require("plenary.async")
local themes = require("config.packer-config.modules.themes").ts_themes
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

    -- require("config.core.highlights")
  end
end

M.get_themes = function()
  local res = {}
  for theme_name, _ in pairs(themes) do
    table.insert(res, theme_name)
  end
  return res
end

return M
