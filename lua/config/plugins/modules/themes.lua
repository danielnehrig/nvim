---@module 'lazy.types'

---@class PluginColorschemes: LazyPluginSpec
---@field colorscheme_name string[] this is needed because there is no real way to know the colorscheme name

---@class themes
---@field theme table<string, LazyPluginSpec>
---@field ts_themes table<string, PluginColorschemes>
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
  ["HampusHauffman/bionic.nvim"] = {
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  },
  --- INFO: shows indentation scopes with different background highlight making it a block
  ["HampusHauffman/block.nvim"] = {
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {}
  },
  ["projekt0n/github-nvim-theme"] = {
    tag = "v0.0.7",
    lazy = true,
  },
  --- INFO: highlight function params
  ["m-demare/hlargs.nvim"] = {
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = true,
    config = function()
      require("hlargs").setup()
    end,
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
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      require("config.plugins.configs.bufferline").init()
    end,
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },
}

M.ts_themes = {
  ["sainnhe/sonokai"] = {
    colorscheme_name = { "sonokai" },
    lazy = true,
    priority = 1000,
    opts = {},
  },
  ["ray-x/aurora"] = {
    colorscheme_name = { "aurora" },
    lazy = true,
    priority = 1000,
    opts = {},
  },
  ["Mofiqul/vscode.nvim"] = {
    colorscheme_name = { "vscode" },
    lazy = true,
    priority = 1000,
    opts = {},
  },
  ["marko-cerovac/material.nvim"] = {
    colorscheme_name = { "material" },
    lazy = true,
    priority = 1000,
    opts = {},
    config = function()
      require("material").setup({})
    end,
  },
  ["Murtaza-Udaipurwala/gruvqueen"] = {
    colorscheme_name = { "gruvqueen" },
    lazy = true,
    priority = 1000,
    opts = {},
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
    colorscheme_name = {
      "tokyonight",
      "tokyonight-night",
      "tokyonight-storm",
      "tokyonight-day",
      "tokyonight-moon",
    },
    lazy = true,
    priority = 1000,
    opts = {},
  },
}

return M
