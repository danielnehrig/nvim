---@module 'lazy.types'

---@class treesitter
---@field ts table<string, LazyPluginSpec>
local M = {}

M.ts = {
  -- INFO: hihglight current chunk
  ["shellRaining/hlchunk.nvim"] = {
    event = "UIEnter",
    config = function()
      require("hlchunk").setup({
        blank = {
          enable = false,
        },
        line_num = {
          enable = false,
        },
        indent = {
          enable = false,
        },
      })
    end,
  },
  --- TODO: ?
  ["Wansmer/treesj"] = {
    keys = { "<space>m", "<space>j", "<space>s" },
    opts = { use_default_keymaps = false, max_join_length = 150 },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({})
    end,
  },
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
  ["nvim-treesitter/nvim-treesitter"] = {},
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
        hooks = {
          before_comment = require("ts_context_commentstring.internal").update_commentstring,
        },
      })
    end,
  },
  -- INFO: textobject movements like change inside argument jump to function
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = true,
  },
  -- INFO: show ts nodes etc
  ["nvim-treesitter/playground"] = {
    cmd = "TSPlaygroundToggle",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  -- INFO: textsubject movements
  ["RRethy/nvim-treesitter-textsubjects"] = {
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = true,
  },
  -- INFO: add auto tags
  ["windwp/nvim-ts-autotag"] = {
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = true,
  },
}

return M
