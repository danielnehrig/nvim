local M = {}

-- globals
vim.o.background = "dark"
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = true
vim.g.tokyonight_transparent_sidebar = true

-- treesitter themes
M.ts_themes = {
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
            transparent_background = true,
            -- bg_color = "black",
          },
        })

        vim.cmd([[colorscheme gruvqueen]])
        require("config.core.highlights")
      end,
    },
  },
  ["tokyonight"] = {
    colorscheme = "tokyonight",
    packadd = "tokyonight.nvim",
    packer_cfg = {
      "folke/tokyonight.nvim",
      opt = true,
      config = function()
        vim.cmd([[colorscheme tokyonight]])
        require("config.core.highlights")
      end,
    },
  },
}

return M
