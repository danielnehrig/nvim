local colors = require("config.themes").get_colors("base_30")

---@type table<string, Highlight>
local devicons = {
  DevIconc = { bg = "NONE", fg = colors.blue },
  DevIconcss = { bg = "NONE", fg = colors.blue },
  DevIcondeb = { bg = "NONE", fg = colors.cyan },
  DevIconDockerfile = { bg = "NONE", fg = colors.cyan },
  DevIconhtml = { bg = "NONE", fg = colors.baby_pink },
  DevIconjpeg = { bg = "NONE", fg = colors.dark_purple },
  DevIconjpg = { bg = "NONE", fg = colors.dark_purple },
  DevIconjs = { bg = "NONE", fg = colors.sun },
  DevIconkt = { bg = "NONE", fg = colors.orange },
  DevIconlock = { bg = "NONE", fg = colors.red },
  DevIconlua = { bg = "NONE", fg = colors.blue },
  DevIconmp3 = { bg = "NONE", fg = colors.white },
  DevIconmp4 = { bg = "NONE", fg = colors.white },
  DevIconout = { bg = "NONE", fg = colors.white },
  DevIconpng = { bg = "NONE", fg = colors.dark_purple },
  DevIconpy = { bg = "NONE", fg = colors.cyan },
  DevIcontoml = { bg = "NONE", fg = colors.blue },
  DevIconts = { bg = "NONE", fg = colors.teal },
  DevIconttf = { bg = "NONE", fg = colors.white },
  DevIconrb = { bg = "NONE", fg = colors.pink },
  DevIconrpm = { bg = "NONE", fg = colors.orange },
  DevIconvue = { bg = "NONE", fg = colors.vibrant_green },
  DevIconwoff = { bg = "NONE", fg = colors.white },
  DevIconwoff2 = { bg = "NONE", fg = colors.white },
  DevIconxz = { bg = "NONE", fg = colors.sun },
  DevIconzip = { bg = "NONE", fg = colors.sun },
}

return devicons
