---@module 'config.core.config.type'

---@class Config
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
  hl_override = {
    --  ["DiffAdded"] = {
    --  fg = "#ffffff",
    --  bg = "#ffffff",
    --  },
  },
}

default_config.mappings = {
  --  n = {
  --  { "<leader>xx", "<cmd>lua vim.notify('hehe')<cr>", { desc = "Test" } },
  --  },
}

default_config.plugins = {
  user = {},
  remove = {},
  -- remove = { "hkupty/nvimux" },
}

return default_config
