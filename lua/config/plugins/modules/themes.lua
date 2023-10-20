---@module 'lazy.types'

---@class themes
---@field theme table<string, LazyPluginSpec>
local M = {}

-- globals
vim.o.background = "dark"
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = not vim.g.neovide and true or false
vim.g.tokyonight_transparent_sidebar = not vim.g.neovide and true or false

vim.g.vscode_style = "dark"
vim.g.vscode_transparent = not vim.g.neovide and 1 or 0
vim.g.vscode_italic_comment = 1
vim.g.vscode_disable_nvimtree_bg = not vim.g.neovide and true or false

vim.g.sonokai_style = "andromeda"
vim.g.sonokai_better_performance = 1

vim.g.gruvbox_baby_function_style = "NONE"
vim.g.gruvbox_baby_keyword_style = "italic"
vim.g.gruvbox_baby_highlights = {
  Normal = { fg = "#123123", bg = "NONE", style = "underline" },
}
vim.g.gruvbox_baby_telescope_theme = 1
vim.g.gruvbox_baby_transparent_mode = not vim.g.neovide and 1 or 0

vim.g.tokyodark_transparent_background = not vim.g.neovide and true or false
vim.g.tokyodark_enable_italic_comment = true
vim.g.tokyodark_enable_italic = true
vim.g.tokyodark_color_gamma = "1"

M.theme = {
  --- INFO: highlight start of words bold
  ["HampusHauffman/bionic.nvim"] = {},
  --- INFO: shows indentation scopes with different background highlight making it a block
  ["HampusHauffman/block.nvim"] = {
    config = function()
      require("block").setup({
        percent = 0.8,
        depth = 4,
        colors = nil,
        automatic = false,
        --      bg = nil,
        --      colors = {
        --          "#ff0000"
        --          "#00ff00"
        --          "#0000ff"
        --      },
      })
    end,
    enabled = true,
  },
  ["projekt0n/github-nvim-theme"] = {
    tag = "v0.0.7",
    lazy = true,
  },
  --- INFO: highlight function params
  ["m-demare/hlargs.nvim"] = {
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("hlargs").setup()
    end,
  },
  --- INFO:  display of emptyspaces/indentations vertical bars
  ["lukas-reineke/indent-blankline.nvim"] = {
    config = require("config.plugins.configs.indent-blankline").init,
    lazy = true,
    event = "BufRead",
  },
  --- INFO: dashboard plugin
  ["goolord/alpha-nvim"] = {
    config = require("config.plugins.configs.dashboard").dashboard,
  },
  --- INFO: the statusline builder im using
  ["windwp/windline.nvim"] = {
    event = "VeryLazy",
    config = function()
      local config = require("config.core.config").config
      require("config.plugins.configs.statusline.windline").switch_theme(
        config.ui.statusline.name
      )
    end,
  },
  ["romgrk/barbar.nvim"] = {
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },
}

M.ts_themes = {
  ["sainnhe/sonokai"] = {
    lazy = true,
  },
  ["ray-x/aurora"] = {
    lazy = true,
  },
  ["Mofiqul/vscode.nvim"] = {
    lazy = true,
  },
  ["marko-cerovac/material.nvim"] = {
    lazy = true,
    config = function()
      require("material").setup()
    end,
  },
  ["Murtaza-Udaipurwala/gruvqueen"] = {
    lazy = true,
    config = function()
      vim.o.background = "dark"
      require("gruvqueen").setup({
        config = {
          disable_bold = true,
          italic_comments = true,
          italic_keywords = true,
          italic_functions = true,
          italic_variables = true,
          invert_selection = false,
          style = "mix", -- possible values: 'original', 'mix', 'material'
          transparent_background = not vim.g.neovide and true or false,
          -- bg_color = "black",
        },
      })
    end,
  },
  ["folke/tokyonight.nvim"] = {
    lazy = true,
  },
}

return M
