---@module 'config.core.config.type'

---@class ConfigSetup
local default_config = {}

default_config.ui = {
  changed_themes = {
    --  ["radium"] = {
    --  base_16 = {
    --  base08 = "#ffffff",
    --  base0C = "#ffffff",
    --  },
    --  },
  },
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

default_config.ai_options = {
  openai_key = nil,
  copilot_key = nil,
}

return default_config
