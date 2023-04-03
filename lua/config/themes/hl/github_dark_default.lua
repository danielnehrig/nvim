-- credits to original theme for existing https://github.com/primer/github-vscode-theme
-- This is a modified version of it

local M = {}

M.base_30 = {
  black = "#0d1117",
  black2 = "#2e3338",
  one_bg = "#33383d",
  one_bg2 = "#383d42", -- StatusBar (filename)
  one_bg3 = "#42474c",
  bright_black = "#6e7681",
  darker_black = "#1F2428",
  white = "#f0f6fc",
  bright_white = "#f0f6fc",
  red = "#ff7b72",
  bright_red = "#ffa198",
  green = "#3fb950",
  bright_green = "#56d364",
  yellow = "#e3b341",
  bright_yellow = "#e3b341",
  blue = "#58a6ff",
  bright_blue = "#79c0ff",
  magenta = "#bc8cff",
  bright_magenta = "#d2a8ff",
  cyan = "#39c5cf",
  bright_cyan = "#56d4dd",
  pmenu_bg = "#58a6ff", -- Command bar suggestions
  folder_bg = "#58a6ff",
}

M.base_16 = {
  base00 = "#0d1117", -- Default bg
  base01 = "#33383d", -- Lighter bg (status bar, line number, folding mks)
  base02 = "#383d42", -- Selection bg
  base03 = "#42474c", -- Comments, invisibles, line hl
  base04 = "#4c5156", -- Dark fg (status bars)
  base05 = "#c9d1d9", -- Default fg (caret, delimiters, Operators)
  base06 = "#d3dbe3", -- Light fg (not often used)
  base07 = "#dde5ed", -- Light bg (not often used)
  base08 = "#f3a965", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = "#f3a965", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = "#f3a965", -- Classes, Markup Bold, Search Text Background
  base0B = "#a5d6ff", -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = "#83caff", -- Support, regex, escape chars
  base0D = "#bc8cff", -- Function, methods, headings
  base0E = "#ff7b72", -- Keywords
  base0F = "#3fb950", -- Deprecated, open/close embedded tags
}

M.type = "dark"

M.polish_hl = {
  ["@punctuation.bracket"] = {
    fg = M.base_30.yellow,
  },

  ["@string"] = {
    fg = M.base_30.blue,
  },

  ["@field.key"] = {
    fg = M.base_30.white,
  },

  ["@constructor"] = {
    fg = M.base_30.bright_green,
    bold = true,
  },

  ["@lsp.type.struct"] = { fg = M.base_30.yellow },

  ["@tag.attribute"] = {
    link = "@method",
  },
}

M = require("config.themes").override_theme(M, "github_dark")

return M
