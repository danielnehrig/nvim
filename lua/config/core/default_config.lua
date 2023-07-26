---@module 'config.core.config.type'

---@type Config
local default_config = {}

default_config.ui = {
  changed_themes = {},
  logo = "neovim.cat",
  transparent = false,
  colorscheme = {
    name = "github_dark_default",
    toggle = { "github_dark_default", "radium" },
  },
  statusline = {
    name = "slanted_lsp",
    separator = { "slant_right", "slant_left" },
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
  user = {
    --  ["user/plugin.nvim"] = {
    --  config = function ()
    --  -- code
    --  end,
    --  },
  },
  remove = {
    --  "hkupty/nvimux",
  },
}

return default_config
