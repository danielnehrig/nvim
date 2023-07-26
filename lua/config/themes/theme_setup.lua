local merge_tb = vim.tbl_deep_extend
local config = require("config.core.config").config

local ui = config.ui

---@type table<string, Highlight>
local highlights = {}
local hl_dir = vim.fn.stdpath("config") .. "/lua/config/themes/integrations"

-- push hl_dir file names to table
local hl_files = require("plenary.scandir").scan_dir(hl_dir, {})

for _, file in ipairs(hl_files) do
  local a = vim.fn.fnamemodify(file, ":t")
  a = vim.fn.fnamemodify(a, ":r")

  ---@type table<string, Highlight>
  local integration = require("config.themes.integrations." .. a)
  highlights = merge_tb("force", highlights, integration)
end

-- term colors
require("config.themes.termhl")

-- polish theme specific highlights
local polish_hl = require("config.themes").get_colors("polish_hl")

if polish_hl then
  highlights = merge_tb("force", highlights, polish_hl)
end

if ui.transparent then
  highlights = merge_tb("force", highlights, require("config.themes.glassy"))
end

if ui.hl_override then
  local overriden_hl =
    require("config.themes").turn_str_to_color(ui.hl_override)

  highlights = merge_tb("force", highlights, overriden_hl)
end

-- finally set all highlights :D
for hl, col in pairs(highlights) do
  vim.api.nvim_set_hl(0, hl, col)
end
