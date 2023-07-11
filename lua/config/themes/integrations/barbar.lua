local theme = require("config.themes").get_colors("base_30")
local util = require("config.themes.util")

return {
  BufferCurrent = { bg = theme.darker_black, fg = theme.white },
  BufferCurrentERROR = { bg = theme.darker_black, fg = theme.red },
  BufferCurrentHINT = { bg = theme.darker_black, fg = theme.blue },
  BufferCurrentINFO = { bg = theme.darker_black, fg = theme.blue },
  BufferCurrentWARN = { bg = theme.darker_black, fg = theme.yellow },
  BufferCurrentIndex = { bg = theme.statusline_bg, fg = theme.nord_blue },
  BufferCurrentMod = { bg = theme.darker_black, fg = theme.orange },
  BufferCurrentSign = { bg = theme.darker_black, fg = theme.statusline_bg },
  BufferCurrentTarget = { bg = theme.darker_black, fg = theme.red },
  --  BufferAlternate = { bg = c.fg_gutter, fg = c.fg },
  --  BufferAlternateERROR = { bg = c.fg_gutter, fg = c.error },
  --  BufferAlternateHINT = { bg = c.fg_gutter, fg = c.hint },
  BufferAlternateIndex = { bg = theme.grey_fg, fg = theme.blue },
  --  BufferDefaultInactiveIndex = { bg = theme.grey_fg, fg = theme.blue },
  --  BufferAlternateINFO = { bg = c.fg_gutter, fg = c.info },
  --  BufferAlternateMod = { bg = c.fg_gutter, fg = c.warning },
  --  BufferAlternateSign = { bg = c.fg_gutter, fg = c.info },
  --  BufferAlternateTarget = { bg = c.fg_gutter, fg = c.red },
  --  BufferAlternateWARN = { bg = c.fg_gutter, fg = c.warning },
  BufferVisible = { bg = theme.black2, fg = theme.white },
  --  BufferVisibleERROR = { bg = c.bg_statusline, fg = c.error },
  --  BufferVisibleHINT = { bg = c.bg_statusline, fg = c.hint },
  --  BufferVisibleINFO = { bg = c.bg_statusline, fg = c.info },
  --  BufferVisibleWARN = { bg = c.bg_statusline, fg = c.warning },
  BufferVisibleIndex = { bg = theme.statusline_bg, fg = theme.statusline_bg },
  BufferVisibleMod = { bg = theme.statusline_bg, fg = theme.yellow },
  BufferVisibleSign = { bg = theme.statusline_bg, fg = theme.statusline_bg },
  BufferVisibleTarget = { bg = theme.statusline_bg, fg = theme.red },
  BufferInactive = {
    bg = util.darken(theme.black, 0.4),
    fg = util.darken(theme.white, 0.5),
  },
  --  BufferInactiveERROR = {
  --  bg = util.darken(c.bg_highlight, 0.4),
  --  fg = util.darken(c.error, 0.8),
  --  },
  --  BufferInactiveHINT = {
  --  bg = util.darken(c.bg_highlight, 0.4),
  --  fg = util.darken(c.hint, 0.8),
  --  },
  --  -- BufferInactiveIcon = { bg = c.bg_statusline, fg = util.darken(c., 0.1) },
  --  BufferInactiveINFO = {
  --  bg = util.darken(c.bg_highlight, 0.4),
  --  fg = util.darken(c.info, 0.8),
  --  },
  --  BufferInactiveWARN = {
  --  bg = util.darken(c.bg_highlight, 0.4),
  --  fg = util.darken(c.warning, 0.8),
  --  },
  BufferInactiveIndex = {
    bg = util.darken(theme.black, 0.4),
    fg = theme.black,
  },
  BufferInactiveMod = {
    bg = util.darken(theme.one_bg, 0.4),
    fg = util.darken(theme.yellow, 0.8),
  },
  BufferInactiveSign = {
    bg = util.darken(theme.statusline_bg, 0.8),
    fg = theme.statusline_bg,
  },
  BufferInactiveTarget = { bg = util.darken(theme.one_bg, 0.4), fg = theme.red },
  BufferOffset = { bg = theme.one_bg, fg = theme.one_bg3 },
  BufferTabpageFill = {
    bg = util.darken(theme.one_bg, 0.8),
    fg = theme.one_bg3,
  },
  BufferTabpages = { bg = theme.statusline_bg, fg = theme.white },
}
