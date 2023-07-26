local theme = require("config.themes").get_colors("base_16")

---@type table<string, Highlight>
local mail = {
  mailQuoted1 = {
    fg = theme.base0A,
  },

  mailQuoted2 = {
    fg = theme.base0B,
  },

  mailQuoted3 = {
    fg = theme.base0E,
  },

  mailQuoted4 = {
    fg = theme.base0C,
  },

  mailQuoted5 = {
    fg = theme.base0D,
  },

  mailQuoted6 = {
    fg = theme.base0A,
  },

  mailURL = {
    fg = theme.base0D,
  },

  mailEmail = {
    fg = theme.base0D,
  },
}

return mail
