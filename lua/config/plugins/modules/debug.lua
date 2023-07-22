---@module 'config.plugins.modules.types'

---@class debug
---@field debug table<string, PluginInterfaceMerged>
local M = {}

M.debug = {
  ["nvim-neotest/neotest"] = {
    cmd = { "Neotest" },
    config = function()
      require("neotest").setup({
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
        overseer = {
          enabled = true,
          -- When this is true (the default), it will replace all neotest.run.* commands
          force_default = false,
        },
        adapters = {
          require("neotest-rust")({
            args = { "--no-capture" },
          }),
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "custom.jest.config.ts",
            env = { CI = true },
            cwd = function(_)
              return vim.fn.getcwd()
            end,
          }),
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "haydenmeade/neotest-jest",
      "rouge8/neotest-rust",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
  },
  ["jbyuki/one-small-step-for-vimkind"] = {},
  ["mfussenegger/nvim-dap-python"] = {
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  ["mfussenegger/nvim-dap"] = {
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  ["rcarriga/nvim-dap-ui"] = {
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
  },
}

return M
