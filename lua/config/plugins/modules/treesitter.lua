---@module 'lazy.types'

---@class treesitter
---@field ts table<string, LazyPluginSpec>
local M = {}

M.ts = {
  --- INFO: refactor plugin
  ["ThePrimeagen/refactoring.nvim"] = {
    config = require("config.plugins.configs.refactoring").init,
    event = "BufRead",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
    },
  },
  --- INFO: display cursor syntax struct context in winbar buffer
  ["SmiteshP/nvim-navic"] = {
    dependencies = "neovim/nvim-lspconfig",
    lazy = true,
    config = function()
      local navic = require("nvim-navic")
      navic.setup({
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
      })
    end,
  },
  ["nvim-treesitter/nvim-treesitter"] = {
    config = function()
      require("config.plugins.configs.treesitter").init()
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-context",
    },
  },
  ["Wansmer/treesj"] = {
    event = "VeryLazy",
    opts = { use_default_keymaps = false, max_join_length = 150 },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({})
    end,
  },
  --- INFO:  indenter
  ["yioneko/nvim-yati"] = {
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  --- INFO: doc generation
  ["danymat/neogen"] = {
    cmd = { "DocGen" },
    config = require("config.plugins.configs.neogen").init,
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  --- INFO: treesitter aware commenting
  ["JoosepAlviste/nvim-ts-context-commentstring"] = {
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  --- INFO: treesitter aware commenting
  ["winston0410/commented.nvim"] = {
    keys = {
      { "gcc", mode = { "n", "v" }, desc = "Comment out line" },
    },
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("commented").setup({
        keybindings = { n = "gc", v = "gc", nl = "gcc" },
        hooks = {
          before_comment = require("ts_context_commentstring.internal").update_commentstring,
        },
      })
    end,
  },
  -- INFO: show ts nodes etc
  ["nvim-treesitter/playground"] = {
    cmd = "TSPlaygroundToggle",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
}

return M
