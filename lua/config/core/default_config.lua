local default_config = {}

default_config.ui = {
  changed_themes = {},
  transparent = false,
  colorscheme = {
    name = "github_dark_default",
    toggle = { "github_dark_default", "radium" },
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
