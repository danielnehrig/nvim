local theme = require("config.themes").get_colors("base_30")
local theme_16 = require("config.themes").get_colors("base_16")
local util = require("config.themes.util")

---@type table<string, Highlight>
local barbar = {
  BufferCurrent = { bg = theme.darker_black, fg = theme.white },
  BufferCurrentNumber = { bg = theme.darker_black, fg = theme.white },
  BufferCurrentIcon = { bg = theme.darker_black },
  BufferCurrentERROR = { bg = theme.darker_black, fg = theme.red },
  BufferCurrentHINT = { bg = theme.darker_black, fg = theme.blue },
  BufferCurrentINFO = { bg = theme.darker_black, fg = theme.blue },
  BufferCurrentWARN = { bg = theme.darker_black, fg = theme.yellow },
  BufferCurrentIndex = { bg = theme.statusline_bg, fg = theme.nord_blue },
  BufferCurrentMod = { bg = theme.darker_black, fg = theme.orange },
  BufferCurrentSign = { bg = theme.darker_black, fg = theme_16.base0F },
  BufferCurrentSignRight = {
    bg = theme.darker_black,
    --fg = theme_16.base0F
    fg = theme.yellow,
  },
  BufferCurrentTarget = { bg = theme.darker_black, fg = theme.red },
  BufferAlternate = { bg = theme.grey_fg, fg = theme.white },
  BufferAlternateIcon = { bg = theme.grey_fg },
  BufferAlternateERROR = { bg = theme.grey_fg, fg = theme.red },
  BufferAlternateHINT = { bg = theme.grey_fg, fg = theme.cyan },
  BufferAlternateIndex = { bg = theme.grey_fg, fg = theme.blue },
  --  BufferAlternateINFO = { bg = c.fg_gutter, fg = c.info },
  --  BufferAlternateMod = { bg = c.fg_gutter, fg = c.warning },
  BufferAlternateSign = { bg = theme.statusline_bg, fg = theme.yellow },
  BufferAlternateSignRight = { bg = theme.statusline_bg, fg = theme.yellow },
  --  BufferAlternateTarget = { bg = c.fg_gutter, fg = c.red },
  --  BufferAlternateWARN = { bg = c.fg_gutter, fg = c.warning },
  BufferVisible = { bg = theme.statusline_bg, fg = theme.white },
  --  BufferVisibleERROR = { bg = c.bg_statusline, fg = c.error },
  --  BufferVisibleHINT = { bg = c.bg_statusline, fg = c.hint },
  --  BufferVisibleINFO = { bg = c.bg_statusline, fg = c.info },
  --  BufferVisibleWARN = { bg = c.bg_statusline, fg = c.warning },
  BufferVisibleIcon = { bg = theme.statusline_bg },
  BufferVisibleIndex = { bg = theme.statusline_bg, fg = theme.statusline_bg },
  BufferVisibleMod = { bg = theme.statusline_bg, fg = theme.orange },
  BufferVisibleSign = { bg = theme.statusline_bg, fg = theme.yellow },
  BufferVisibleSignRight = { bg = theme.statusline_bg, fg = theme.yellow },
  BufferVisibleTarget = { bg = theme.statusline_bg, fg = theme.red },
  BufferInactiveIcon = { bg = util.darken(theme.black, 0.4) },
  BufferInactive = {
    bg = util.darken(theme.black, 0.4),
    fg = util.darken(theme.white, 0.5),
  },
  BufferInactiveIndex = {
    bg = util.darken(theme.black, 0.4),
    fg = theme.black,
  },
  BufferInactiveMod = {
    bg = util.darken(theme.one_bg, 0.4),
    fg = util.darken(theme.orange, 0.8),
  },
  BufferInactiveSign = {
    bg = util.darken(theme.black, 0.4),
    fg = util.darken(theme.black, 0.4),
  },
  BufferInactiveSignRight = {
    bg = util.darken(theme.black, 0.4),
    --fg = util.darken(theme.black, 0.4),
    fg = theme.yellow,
  },
  BufferInactiveTarget = { bg = util.darken(theme.one_bg, 0.4), fg = theme.red },
  --BufferTabpageFill = { bg = theme.darker_black, fg = theme.white },
}

return barbar
