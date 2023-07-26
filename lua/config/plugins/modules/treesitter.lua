---@module 'lazy.types'

---@class treesitter
---@field ts table<string, LazyPluginSpec>
local M = {}

M.ts = {
  ["Wansmer/treesj"] = {
    keys = { "<space>m", "<space>j", "<space>s" },
    opts = { use_default_keymaps = false, max_join_length = 150 },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({})
    end,
  },
  ["ThePrimeagen/refactoring.nvim"] = {
    config = require("config.plugins.configs.refactoring").init,
    event = "BufRead",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
    },
  },
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
  ["nvim-treesitter/nvim-treesitter"] = {},
  ["yioneko/nvim-yati"] = {
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  ["danymat/neogen"] = {
    cmd = { "DocGen" },
    config = require("config.plugins.configs.neogen").init,
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  ["JoosepAlviste/nvim-ts-context-commentstring"] = {
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  ["winston0410/commented.nvim"] = {
    keys = {
      { "<space>cc", mode = { "n", "v" }, desc = "Comment out line" },
    },
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("commented").setup({
        hooks = {
          before_comment = require("ts_context_commentstring.internal").update_commentstring,
        },
      })
    end,
  },
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = true,
  },
  ["nvim-treesitter/playground"] = {
    cmd = "TSPlaygroundToggle",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  ["RRethy/nvim-treesitter-textsubjects"] = {
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = true,
  },
  ["windwp/nvim-ts-autotag"] = {
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = true,
  },
}

return M
