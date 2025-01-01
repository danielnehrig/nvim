---@module 'lazy.types'

---@class debug
---@field debug table<string, LazyPluginSpec>
local M = {}

M.debug = {
  --- INFO: run tests integrated with overseer for task run
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
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "haydenmeade/neotest-jest",
      "rouge8/neotest-rust",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  --- INFO: lua neovim debug
  ["jbyuki/one-small-step-for-vimkind"] = {
    lazy = true,
  },
  --- INFO: py debug
  ["mfussenegger/nvim-dap-python"] = {
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  --- INFO: main debug plug dap
  ["mfussenegger/nvim-dap"] = {
    lazy = true,
  },
  --- INFO: ui for dap
  ["rcarriga/nvim-dap-ui"] = {
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  --- INFO: virt text fot dap
  ["theHamsta/nvim-dap-virtual-text"] = {
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
  },
}

return M
