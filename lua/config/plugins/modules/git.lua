local M = {}

M.git = {
  {
    "ldelossa/gh.nvim",
    requires = { "ldelossa/litee.nvim" },
    config = function()
      require("litee.lib").setup()
      require("litee.gh").setup()
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    config = require("config.plugins.configs.gitsigns").init,
    requires = {
      { "nvim-lua/plenary.nvim", after = "gitsigns.nvim" },
    },
  },
  {
    "tpope/vim-fugitive",
    opt = true,
    cmd = { "Git", "Git mergetool" },
  },
  { "kdheepak/lazygit.nvim", cmd = { "LazyGit" } },
  {
    "TimUntersberger/neogit",
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        disable_signs = true,
        disable_hint = false,
      })
    end,
    requires = "nvim-lua/plenary.nvim",
  },
  {
    "ruifm/gitlinker.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
    },
    opt = true,
  },
  {
    "tanvirtin/vgit.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
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
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup()
    end,
  },
  {
    "danielnehrig/github-ci.nvim",
    requires = { "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
    cmd = { "GithubCI" },
    config = function()
      vim.cmd([[packadd nvim-notify]])
      require("githubci").setup()
    end,
  },
}
return M
