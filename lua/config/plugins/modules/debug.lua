local M = {}

M.debug = {
  ["nvim-neotest/neotest"] = {
    opt = true,
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
  },
  ["vim-test/vim-test"] = {
    cmd = { "TestFile" },
    requires = {
      {
        "neomake/neomake",
        cmd = { "Neomake" },
      },
      { "tpope/vim-dispatch", cmd = { "Dispatch" } },
    },
    wants = { "vim-dispatch", "neomake" },
  },
  ["jbyuki/one-small-step-for-vimkind"] = {},
  ["mfussenegger/nvim-dap-python"] = { opt = true },
  ["Pocco81/dap-buddy.nvim"] = {},
  ["mfussenegger/nvim-dap"] = {
    opt = true,
  },
  ["rcarriga/nvim-dap-ui"] = {
    opt = true,
    requires = { "mfussenegger/nvim-dap" },
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    opt = true,
    requires = { "mfussenegger/nvim-dap" },
  },
}

return M
