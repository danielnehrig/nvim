---@module 'lazy.types'

---@class navigation
---@field navigation table<string, LazyPluginSpec>
local M = {}

M.navigation = {
  --- INFO: % motion
  ["andymass/vim-matchup"] = {
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  --- INFO: tmuxish behaviour in vim
  ["hkupty/nvimux"] = {
    keys = { "<C-a>" },
    config = require("config.plugins.configs.nvimux").init,
  },
  --- INFO: file picker / grep search etc anything fuzzy related
  ["nvim-telescope/telescope.nvim"] = {
    cmd = { "Telescope" },
    config = require("config.plugins.configs.telescope").init,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-project.nvim" },
    },
  },
  --- INFO: drawerboard style file navigator
  ["kyazdani42/nvim-tree.lua"] = {
    dependencies = "kyazdani42/nvim-web-devicons",
    config = require("config.plugins.configs.nvimTree").init,
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
  },
  --- INFO: press tab to get out of ()
  ["abecodes/tabout.nvim"] = {
    config = function()
      require("tabout").setup({
        tabkey = "<Tab>",
        backwards_tabkey = "<S-Tab>",
        act_as_tab = true,
        act_as_shift_tab = false,
        enable_backwards = true,
        completion = true,
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true,
        exclude = {},
      })
    end,
    event = "VeryLazy",
  },
}

return M
