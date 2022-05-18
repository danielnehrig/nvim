local sep_os_replacer = require("config.utils").sep_os_replacer

local M = {}

M.debug = {
  {
    "rcarriga/vim-ultest",
    cmd = { "Ultest" },
    requires = { "vim-test/vim-test" },
    run = ":UpdateRemotePlugins",
  },
  {
    "vim-test/vim-test",
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
  { "jbyuki/one-small-step-for-vimkind" },
  { "mfussenegger/nvim-dap-python", opt = true },
  {
    "Pocco81/DAPInstall.nvim",
    cmd = { "DIInstall", "DIList" },
    config = function()
      local dap_install = require("dap-install")

      dap_install.setup({
        installation_path = sep_os_replacer(
          vim.fn.stdpath("data") .. "/dapinstall/"
        ),
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opt = true,
  },
  {
    "rcarriga/nvim-dap-ui",
    opt = true,
    requires = { "mfussenegger/nvim-dap" },
  },
}

return M
