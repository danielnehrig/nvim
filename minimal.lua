-- File To reproduce issues with a minimal setup
vim.cmd([[set runtimepath=$VIMRUNTIME]])
vim.cmd([[set packpath=/tmp/nvim/site]])
local package_root = "/tmp/nvim/site/pack"
local install_path = package_root .. "/packer/start/packer.nvim"
local function load_plugins()
  require("packer").startup({
    {
      "wbthomason/packer.nvim",
      {
        "nvim-telescope/telescope.nvim",
        requires = {
          "nvim-lua/plenary.nvim",
        },
      },
      {
        "nvim-treesitter/nvim-treesitter",
      },
      {
        "anuvyklack/pretty-fold.nvim",
        disable = true, -- crash because of this shit
        config = function()
          require("pretty-fold").setup({
            keep_indentation = false,
            fill_char = "━",
            sections = {
              left = {
                "━ ",
                function()
                  return string.rep("*", vim.v.foldlevel)
                end,
                " ━┫",
                "content",
                "┣",
              },
              right = {
                "┫ ",
                "number_of_folded_lines",
                ": ",
                "percentage",
                " ┣━━",
              },
            },
          })
          require("pretty-fold").ft_setup("cpp", {
            process_comment_signs = false,
            comment_signs = {
              "/**", -- c++ doxygen comments
            },
            stop_words = {
              "%s%*", -- a space and star char
              "@brief%s*", -- '@brief' and any number of spaces after
              -- or in sigle pattern:
              -- '%*%s*@brief%s*', -- * -> any number of spaces -> @brief -> all spaces after
            },
          })
          require("pretty-fold").ft_setup("javascriptreact", {
            process_comment_signs = false,
            comment_signs = {
              "/**", -- c++ doxygen comments
            },
            stop_words = {
              "%s%*", -- a space and star char
              "@brief%s*", -- '@brief' and any number of spaces after
              -- or in sigle pattern:
              -- '%*%s*@brief%s*', -- * -> any number of spaces -> @brief -> all spaces after
            },
          })
          require("pretty-fold").ft_setup("typescript", {
            process_comment_signs = false,
            comment_signs = {
              "/**", -- c++ doxygen comments
            },
            stop_words = {
              "%s%*", -- a space and star char
              "@brief%s*", -- '@brief' and any number of spaces after
              -- or in sigle pattern:
              -- '%*%s*@brief%s*', -- * -> any number of spaces -> @brief -> all spaces after
            },
          })
          require("pretty-fold").ft_setup("typescriptreact", {
            process_comment_signs = false,
            comment_signs = {
              "/**", -- c++ doxygen comments
            },
            stop_words = {
              "%s%*", -- a space and star char
              "@brief%s*", -- '@brief' and any number of spaces after
              -- or in sigle pattern:
              -- '%*%s*@brief%s*', -- * -> any number of spaces -> @brief -> all spaces after
            },
          })
          require("pretty-fold").ft_setup("typescript", {
            process_comment_signs = false,
            comment_signs = {
              "/**", -- c++ doxygen comments
            },
            stop_words = {
              "%s%*", -- a space and star char
              "@brief%s*", -- '@brief' and any number of spaces after
              -- or in sigle pattern:
              -- '%*%s*@brief%s*', -- * -> any number of spaces -> @brief -> all spaces after
            },
          })
          require("pretty-fold.preview").setup({ border = "rounded" })
        end,
      },
      -- ADD PLUGINS THAT ARE _NECESSARY_ FOR REPRODUCING THE ISSUE
    },
    config = {
      package_root = package_root,
      compile_path = install_path .. "/plugin/packer_compiled.lua",
      display = { non_interactive = true },
    },
  })
end
_G.load_config = function()
  require("telescope").setup({})
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
  vim.wo.foldnestmax = 3
  vim.wo.foldminlines = 1

  vim.keymap.set({ "n" }, "<space>ff", ":Telescope find_files<CR>", {
    silent = true,
  })
  require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
  })
end
if vim.fn.isdirectory(install_path) == 0 then
  print("Installing Telescope and dependencies.")
  vim.fn.system({
    "git",
    "clone",
    "--depth=1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end
load_plugins()
require("packer").sync()
vim.cmd(
  [[autocmd User PackerComplete ++once echo "Ready!" | lua load_config()]]
)
