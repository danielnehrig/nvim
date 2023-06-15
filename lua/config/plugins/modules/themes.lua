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
  ["HampusHauffman/block.nvim"] = {
    config = function()
        require("block").setup({})
    end,
    lazy = true,
    enabled = false,
  },
  ["projekt0n/github-nvim-theme"] = {
    tag = "v0.0.7",
    lazy = true,
  },
  ["m-demare/hlargs.nvim"] = {
    requires = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("hlargs").setup()
    end,
  },
  ["lukas-reineke/indent-blankline.nvim"] = {
    config = require("config.plugins.configs.indent-blankline").init,
    lazy = true,
    event = "BufRead",
  },
  ["goolord/alpha-nvim"] = {
    config = require("config.plugins.configs.dashboard").dashboard,
  },
  ["windwp/windline.nvim"] = {
    event = "VeryLazy",
  },
  ["romgrk/barbar.nvim"] = { requires = "kyazdani42/nvim-web-devicons", dependencies = {"kyazdani42/nvim-web-devicons"}},
}

M.ts_themes = {
  ["sainnhe/sonokai"] = {
    colorscheme = "sonokai",
    event = "VeryLazy",
    packadd = "sonokai",
    opt = true,
    lazy = true,
  },
  ["ray-x/aurora"] = {
    colorscheme = "aurora",
    event = "VeryLazy",
    packadd = "aurora",
    opt = true,
    lazy = true,
  },
  ["Mofiqul/vscode.nvim"] = {
    colorscheme = "vscode",
    packadd = "vscode.nvim",
    event = "VeryLazy",
    opt = true,
    lazy = true,
    config = function() end,
  },
  ["marko-cerovac/material.nvim"] = {
    colorscheme = "material",
    event = "VeryLazy",
    lazy = true,
    packadd = "material.nvim",
    config = function()
      require("material").setup()
    end,
  },
  ["Murtaza-Udaipurwala/gruvqueen"] = {
    colorscheme = "gruvqueen",
    packadd = "gruvqueen",
    event = "VeryLazy",
    opt = true,
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
    colorscheme = "tokyonight",
    packadd = "tokyonight.nvim",
    event = "VeryLazy",
    opt = true,
    lazy = true,
  },
}

return M
