local global = require("config.core.global")
local use_config = require("config.core.config").get_config
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

-- combines packer colorschemes
-- with internal colorschemes
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

    local highlights_raw =
      vim.split(vim.api.nvim_exec("filter BufferLine hi", true), "\n")
    local highlight_groups = {}

    for _, raw_hi in ipairs(highlights_raw) do
      table.insert(highlight_groups, string.match(raw_hi, "BufferLine%a+"))
    end

    for _, highlight in ipairs(highlight_groups) do
      vim.cmd([[hi clear ]] .. highlight)
    end

    local colorscheme_ok, _ =
      pcall(vim.cmd, string.format("colorscheme %s", colorscheme))

    if not colorscheme_ok then
      vim.notify(
        string.format(
          "colorscheme %s not found or error on setting",
          colorscheme
        )
      )
      return
    end

    local highlights = {}

    global.reload({ "config.plugins.configs.statusline.windline" })
    require("config.plugins.configs.statusline.windline").switch_theme(
      use_config().ui.statusline.name
    )

    if use_config().ui.transparent then
      highlights = vim.tbl_deep_extend(
        "force",
        highlights,
        require("config.themes.glassy")
      )
    end

    for hl, col in pairs(highlights) do
      vim.api.nvim_set_hl(0, hl, col)
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
    require("config.core.config").config.ui.colorscheme.name = colorscheme
    require("config.themes").load_theme()

    require("plenary.reload").reload_module(
      "config.plugins.configs.statusline.theme."
        .. use_config().ui.statusline.name
    )
    require("config.plugins.configs.statusline.windline").switch_theme(
      use_config().ui.statusline.name
    )
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
