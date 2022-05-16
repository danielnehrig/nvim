local M = {}

M.lsp = {
  {
    "folke/lsp-colors.nvim",
    config = function()
      require("lsp-colors").setup({
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981",
      })
    end,
  },
  { "folke/lua-dev.nvim", opt = true }, -- lua nvim setup
  {
    "neovim/nvim-lspconfig",
    config = require("config.plugins.lspconfig").init,
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
    end,
    cmd = { "Trouble" },
    requires = "kyazdani42/nvim-web-devicons",
  },
  {
    "nvim-lua/lsp-status.nvim",
  },
}

return M
