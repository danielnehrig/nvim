local M = {}

M.ts = {
  ["ThePrimeagen/refactoring.nvim"] = {
    config = require("config.plugins.configs.refactoring").init,
    event = "BufRead",
    requires = {
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-lua/plenary.nvim" },
    },
  },
  ["SmiteshP/nvim-gps"] = {
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-gps").setup()
    end,
  },
  ["SmiteshP/nvim-navic"] = {
    requires = "neovim/nvim-lspconfig",
    config = function()
      local navic = require("nvim-navic")
      navic.setup({
        --  icons = {
        --  File = " ",
        --  Module = " ",
        --  Namespace = " ",
        --  Package = " ",
        --  Class = " ",
        --  Method = " ",
        --  Property = " ",
        --  Field = " ",
        --  Constructor = " ",
        --  Enum = "練",
        --  Interface = "練",
        --  Function = " ",
        --  Variable = " ",
        --  Constant = " ",
        --  String = " ",
        --  Number = " ",
        --  Boolean = "◩ ",
        --  Array = " ",
        --  Object = " ",
        --  Key = " ",
        --  Null = "ﳠ ",
        --  EnumMember = " ",
        --  Struct = " ",
        --  Event = " ",
        --  Operator = " ",
        --  TypeParameter = " ",
        --  },
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
      })
    end,
  },
  ["nvim-treesitter/nvim-treesitter"] = {},
  ["yioneko/nvim-yati"] = { requires = "nvim-treesitter/nvim-treesitter" },
  ["danymat/neogen"] = {
    cmd = { "DocGen" },
    config = require("config.plugins.configs.neogen").init,
    requires = "nvim-treesitter/nvim-treesitter",
  },
  ["JoosepAlviste/nvim-ts-context-commentstring"] = {
    requires = "nvim-treesitter/nvim-treesitter",
  },
  ["winston0410/commented.nvim"] = {
    keys = { "<space>cc" },
    config = function()
      require("commented").setup({
        hooks = {
          before_comment = require("ts_context_commentstring.internal").update_commentstring,
        },
      })
    end,
  },
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    requires = "nvim-treesitter/nvim-treesitter",
  },
  ["nvim-treesitter/playground"] = {
    cmd = "TSPlaygroundToggle",
    requires = "nvim-treesitter/nvim-treesitter",
  },
  ["RRethy/nvim-treesitter-textsubjects"] = {
    requires = "nvim-treesitter/nvim-treesitter",
  },
  ["windwp/nvim-ts-autotag"] = {
    requires = "nvim-treesitter/nvim-treesitter",
  },
}

return M
