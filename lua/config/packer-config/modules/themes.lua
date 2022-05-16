local M = {}

-- globals
vim.o.background = "dark"
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = not vim.g.neovide and true or false
vim.g.tokyonight_transparent_sidebar = not vim.g.neovide and true or false

-- Lua:
-- For dark theme
vim.g.vscode_style = "dark"
-- Enable transparent background
vim.g.vscode_transparent = 1
-- Enable italic comment
vim.g.vscode_italic_comment = 1
-- Disable nvim-tree background color
vim.g.vscode_disable_nvimtree_bg = true

-- treesitter themes
M.ts_themes = {
  ["aurora"] = {
    colorscheme = "aurora",
    packadd = "aurora",
    toggle = function() end,
    packer_cfg = {
      "ray-x/aurora",
      opt = true,
    },
  },
  ["vscode"] = {
    colorscheme = "vscode",
    packadd = "vscode.nvim",
    packer_cfg = {
      "Mofiqul/vscode.nvim",
      opt = true,
      config = function() end,
    },
  },
  ["material"] = {
    colorscheme = "material",
    packadd = "material.nvim",
    packer_cfg = {
      "marko-cerovac/material.nvim",
      config = function()
        require("material").setup()
      end,
      opt = true,
    },
  },
  ["gruvbox"] = {
    colorscheme = "gruvqueen",
    packadd = "gruvqueen",
    packer_cfg = {
      "Murtaza-Udaipurwala/gruvqueen",
      opt = true,
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
  },
  ["tokyonight"] = {
    colorscheme = "tokyonight",
    packadd = "tokyonight.nvim",
    packer_cfg = {
      "folke/tokyonight.nvim",
      opt = true,
    },
  },
}

return M
