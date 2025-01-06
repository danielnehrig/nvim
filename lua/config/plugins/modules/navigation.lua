---@module 'lazy.types'

---@class navigation
---@field navigation table<string, LazyPluginSpec>
local M = {}

M.navigation = {
  --- INFO: % motion
  ["andymass/vim-matchup"] = {
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  --- INFO: file picker / grep search etc anything fuzzy related
  ["nvim-telescope/telescope.nvim"] = {
    cmd = { "Telescope" },
    config = require("config.plugins.configs.telescope").init,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        enabled = function()
          local global = require("config.core.global")
          return not global.is_windows
        end,
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
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        exclude = {},
      })
    end,
    event = "VeryLazy",
  },
}

return M
