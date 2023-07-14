---@module 'config.plugins.modules.types'

---@class git
---@field git table<string, PluginInterfaceMerged>
local M = {}

M.git = {
  ["lewis6991/gitsigns.nvim"] = {
    event = { "BufRead", "BufNewFile" },
    config = require("config.plugins.configs.gitsigns").init,
    requires = { "nvim-lua/plenary.nvim" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  ["tpope/vim-fugitive"] = {
    cmd = { "Git", "Git mergetool" },
  },
  ["kdheepak/lazygit.nvim"] = { cmd = { "LazyGit" } },
  ["NeogitOrg/neogit"] = {
    cmd = { "Neogit" },
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        disable_signs = false,
        disable_hint = false,
      })
    end,
    requires = "nvim-lua/plenary.nvim",
  },
  ["ruifm/gitlinker.nvim"] = {
    requires = { "nvim-lua/plenary.nvim" },
    opt = true,
  },
  ["tanvirtin/vgit.nvim"] = {
    requires = {
      "nvim-lua/plenary.nvim",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "VGit" },
    config = function()
      require("vgit").setup({
        settings = {
          live_gutter = {
            enabled = false,
          },
        },
      })
    end,
  },
  ["akinsho/git-conflict.nvim"] = {
    config = function()
      require("git-conflict").setup({})
    end,
  },
  ["danielnehrig/github-ci.nvim"] = {
    requires = { "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
    dependencies = { "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
    cmd = { "GithubCI" },
    config = function()
      require("githubci").setup()
    end,
  },
}
return M
