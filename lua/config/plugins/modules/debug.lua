---@module 'config.plugins.modules.types'

---@class debug
---@field debug table<string, PluginInterfaceMerged>
local M = {}

M.debug = {
  ["nvim-neotest/neotest"] = {
    cmd = { "Neotest" },
    config = function()
      require("neotest").setup({
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
    requires = {
      "nvim-lua/plenary.nvim",
      "haydenmeade/neotest-jest",
      "rouge8/neotest-rust",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "haydenmeade/neotest-jest",
      "rouge8/neotest-rust",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
  },
  ["jbyuki/one-small-step-for-vimkind"] = {},
  ["ravenxrz/DAPInstall.nvim"] = {
    cmd = { "DIInstall", "DIUninstall", "DIList" },
  },
  ["mfussenegger/nvim-dap-python"] = {
    opt = true,
    lazy = true,
    requires = { "mfussenegger/nvim-dap" },
    dependencies = { "mfussenegger/nvim-dap" },
  },
  ["mfussenegger/nvim-dap"] = {
    opt = true,
    lazy = true,
    requires = { "mfussenegger/nvim-dap" },
    dependencies = { "mfussenegger/nvim-dap" },
  },
  ["rcarriga/nvim-dap-ui"] = {
    opt = true,
    lazy = true,
    requires = { "mfussenegger/nvim-dap" },
    dependencies = { "mfussenegger/nvim-dap" },
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    opt = true,
    lazy = true,
    requires = { "mfussenegger/nvim-dap" },
    dependencies = { "mfussenegger/nvim-dap" },
  },
}

return M
