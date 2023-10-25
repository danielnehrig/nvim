---@module 'lazy.types'

---@class git
---@field git table<string, LazyPluginSpec>
local M = {}

M.git = {
  --- INFO: show git hunks and gutter
  ["lewis6991/gitsigns.nvim"] = {
    event = { "BufRead", "BufNewFile" },
    config = require("config.plugins.configs.gitsigns").init,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  --- INFO: scrollbar and gutter/diagnostic display
  ["lewis6991/satellite.nvim"] = {
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("satellite").setup()
    end,
  },
  --- INFO: old vim git integration
  ["tpope/vim-fugitive"] = {
    cmd = { "Git", "Git mergetool" },
  },
  --- INFO: lazygit needs lazygit in path
  ["kdheepak/lazygit.nvim"] = { cmd = { "LazyGit" } },
  --- INFO: neogit
  ["NeogitOrg/neogit"] = {
    cmd = { "Neogit" },
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        disable_signs = false,
        disable_hint = false,
      })
    end,
    dependencies = "nvim-lua/plenary.nvim",
  },
  --- INFO: get a link to current file/line on remote
  ["ruifm/gitlinker.nvim"] = {
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
  },
  --- INFO: visual git show buffer history etc
  ["tanvirtin/vgit.nvim"] = {
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
  --- INFO: Show git conflicts
  ["akinsho/git-conflict.nvim"] = {
    config = function()
      require("git-conflict").setup({})
    end,
  },
}
return M
