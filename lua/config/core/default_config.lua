local default_config = {}

default_config.ui = {
  changed_themes = {},
  transparent = false,
  colorscheme = {
    name = "radium",
    toggle = { "radium", "onedark" },
  },
  statusline = {
    name = "slanted_lsp",
    seperator = "default",
  },
}

default_config.plugins = {
  user = {},
}

return default_config
