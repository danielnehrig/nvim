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
                    {
                        "nvim-telescope/telescope-fzf-native.nvim",
                        run = "make",
                    },
                },
            },
            {
                "nvim-treesitter/nvim-treesitter",
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
    require("telescope").setup()
    require("telescope").load_extension("fzf")
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
    vim.wo.foldtext =
        [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]]
    vim.wo.fillchars = "fold:\\"
    vim.wo.foldnestmax = 3
    vim.wo.foldminlines = 1

    require("nvim-treesitter.configs").setup({
        ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
