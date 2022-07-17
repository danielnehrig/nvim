local M = {}

M.debug = {
  ["rcarriga/neotest"] = {
    requires = {
      "nvim-lua/plenary.nvim",
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
}

return M
