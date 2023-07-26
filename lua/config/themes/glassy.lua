local colors = require("config.themes").get_colors("base_30")

local M = {
  NvimTreeWinSeparator = {
    fg = colors.one_bg2,
    bg = "NONE",
  },

  TelescopeResultsTitle = {
    fg = colors.black,
    bg = colors.blue,
  },
}

-- for hl groups which need bg = "NONE" only!
local hl_groups = {
  "NormalFloat",
  "Normal",
  "Folded",
  "FoldColumn",
  --  "SatelliteBar",
  --  "SatelliteSearch",
  --  "SatelliteCursor",
  --  "SatelliteQuickfix",
  --  "SatelliteMark",
  --  "SatelliteGitSignsAdd",
  --  "SatelliteGitSignsChange",
  --  "SatelliteGitSignsDelete",
  --  "SatelliteDiagnosticWarn",
  --  "SatelliteDiagnosticInfo",
  --  "SatelliteDiagnosticHint",
  --  "SatelliteDiagnosticError",
  "BufferTabpageFill",
  "NvimTreeNormal",
  "NvimTreeNormalNC",
  "NvimTreeCursorLine",
  "TelescopeNormal",
  "TelescopePrompt",
  "TelescopeResults",
  "TelescopePromptNormal",
  "TelescopePromptPrefix",
  "CursorLine",
  "CursorLineNr",
  "Pmenu",
}

for _, groups in ipairs(hl_groups) do
  M[groups] = {
    bg = "NONE",
  }
end

M.TelescopeBorder = {
  fg = colors.grey,
  bg = "NONE",
}

M.TelescopePromptBorder = {
  fg = colors.grey,
  bg = "NONE",
}

return M
