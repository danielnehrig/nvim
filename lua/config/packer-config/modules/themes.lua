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
  {
    "windwp/windline.nvim",
  },
  { "romgrk/barbar.nvim", requires = "kyazdani42/nvim-web-devicons" },
}

-- treesitter themes
M.ts_themes = {
  ["tokyo-dark"] = {
    colorscheme = "tokyodark",
    packadd = "tokyodark.nvim",
    packer_cfg = {
      "tiagovla/tokyodark.nvim",
      opt = true,
    },
  },
  ["gruvbox-baby"] = {
    colorscheme = "gruvbox-baby",
    packadd = "gruvbox-baby",
    packer_cfg = {
      "luisiacc/gruvbox-baby",
      opt = true,
    },
  },
  ["github"] = {
    colorscheme = "github_dark",
    packadd = "github-nvim-theme",
    packer_cfg = {
      "projekt0n/github-nvim-theme",
      opt = true,
      config = function()
        -- Example config in Lua
        require("github-theme").setup({
          theme_style = "dark",
          function_style = "italic",
          sidebars = { "qf", "nvim-tree", "vista_kind", "terminal", "packer" },

          -- Change the "hint" color to the "orange" color, and make the "error" color bright red
          colors = { hint = "orange", error = "#ff0000" },

          -- Overwrite the highlight groups
          overrides = function(c)
            return {
              htmlTag = {
                fg = c.red,
                bg = "#282c34",
                sp = c.hint,
                style = "underline",
              },
              DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
              -- this will remove the highlight groups
              TSField = {},
            }
          end,
        })
      end,
    },
  },
  ["onedark"] = {
    colorscheme = "onedark",
    packadd = "onedark.nvim",
    packer_cfg = {
      "navarasu/onedark.nvim",
      config = function()
        require("onedark").setup({
          style = "darker",
        })
      end,
      opt = true,
    },
  },
  ["sonokai"] = {
    colorscheme = "sonokai",
    packadd = "sonokai",
    packer_cfg = {
      "sainnhe/sonokai",
      opt = true,
    },
  },
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
