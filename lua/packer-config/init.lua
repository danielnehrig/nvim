local execute = vim.api.nvim_command
local fn = vim.fn
local global = require("core.global")
local data_path = global.data_path
local packer_compiled = data_path .. "packer_compiled.vim"
local compile_to_lua = data_path .. "lua" .. global.path_sep .. "_compiled.lua"

local packer = nil
local function init()
    packer = require("packer")
    packer.init(
        {
            compile_path = packer_compiled,
            disable_commands = true,
            git = {clone_timeout = 120}
        }
    )
    packer.reset()
    local use = packer.use

    require("packer").startup {
        function()
            -- theme
            use {"glepnir/galaxyline.nvim", branch = "main", requires = "kyazdani42/nvim-web-devicons"} -- statusbar
            use {"romgrk/barbar.nvim", requires = "kyazdani42/nvim-web-devicons"} -- bufferline
            use "norcalli/nvim-colorizer.lua" -- colors hex
            use {
                "eddyekofo94/gruvbox-flat.nvim",
                config = function()
                    if not vim.g.neovide then
                        vim.g.gruvbox_transparent_bg = 1
                        vim.g.gruvbox_transparent = true
                    end
                    vim.g.gruvbox_terminal_colors = true
                    vim.g.gruvbox_flat_style = "dark"
                    vim.g.gruvbox_flat_style = "hard"
                    vim.cmd "colorscheme gruvbox-flat" -- :)
                    require("core.highlights")
                end
            } -- colorscheme

            -- language
            use {"HerringtonDarkholme/yats.vim", ft = {"typescript", "typescriptreact"}} -- ts syntax
            use {"folke/lua-dev.nvim"} -- lua nvim setup
            use {"rust-lang/rust.vim", ft = {"rust", "rs"}} -- rust language tools
            use {"simrat39/rust-tools.nvim", ft = {"rust", "rs"}} -- rust language tools
            use {
                "iamcco/markdown-preview.nvim",
                run = "cd app && yarn install",
                ft = {"markdown", "md"},
                cmd = "MarkdownPreview"
            } -- markdown previewer
            use {"metakirby5/codi.vim", cmd = {"Codi"}, ft = {"javascript", "typescript", "lua"}} -- code playground in buffer executed
            use "nvim-treesitter/nvim-treesitter" -- syntax highlight indent etc
            use "nvim-treesitter/nvim-treesitter-textobjects" -- custom textobjects
            use {"windwp/nvim-ts-autotag", ft = {"typescriptreact", "javascriptreact", "html"}} -- autotag <>
            use {
                "shuntaka9576/preview-swagger.nvim",
                run = "yarn install",
                ft = {"yaml", "yml"},
                cmd = "SwaggerPreview"
            } -- openapi preview

            -- completion
            use {"ray-x/lsp_signature.nvim", opt = true} -- auto signature trigger
            use {
                "folke/lsp-trouble.nvim",
                config = function()
                    require("plugins.trouble")
                end,
                cmd = {"LspTrouble"},
                event = "BufRead",
                requires = "kyazdani42/nvim-web-devicons"
            } -- window for showing LSP detected issues in code
            use {
                "folke/todo-comments.nvim",
                config = function()
                    require("plugins.todo")
                end,
                cmd = {"TodoQuickFix", "TodoTrouble", "TodoTelescope"}
            } -- show todos in qf
            use {
                "nvim-lua/lsp-status.nvim",
                config = function()
                    require("plugins.lspStatus")
                end
            } -- lsp status
            use "glepnir/lspsaga.nvim" -- fancy popups lsp
            use "onsails/lspkind-nvim" -- lsp extensions stuff
            use {
                "neovim/nvim-lspconfig",
                config = require("plugins.lspconfig").init,
                requires = {"nvim-lua/lsp-status.nvim", after = {"neovim/nvim-lspconfig"}}
            } -- default configs for lsp and setup lsp
            use {
                "hrsh7th/nvim-compe",
                event = "InsertEnter",
                config = require("plugins.compe").init
            } -- completion engine
            use {"tzachar/compe-tabnine", after = "nvim-compe", run = "./install.sh", requires = "hrsh7th/nvim-compe"}
            use {"tamago324/compe-zsh", after = "nvim-compe", requires = "hrsh7th/nvim-compe"}

            -- snip
            use {"rafamadriz/friendly-snippets"}
            use {
                "L3MON4D3/LuaSnip",
                config = function()
                    require("plugins.compe.luasnip")
                end
            } -- snippets

            -- navigation
            use {
                "nvim-telescope/telescope.nvim",
                cmd = {"Telescope"},
                branch = "async_v2",
                config = require("plugins.telescope"),
                requires = {
                    {"nvim-lua/popup.nvim", opt = true},
                    {"nvim-lua/plenary.nvim", opt = true, branch = "async_jobs_v2"},
                    {"nvim-telescope/telescope-project.nvim", opt = true},
                    {"nvim-telescope/telescope-fzf-native.nvim", opt = true, run = "make"}
                }
            } -- fuzzy finder
            use {
                "kyazdani42/nvim-tree.lua",
                requires = "kyazdani42/nvim-web-devicons",
                cmd = {"NvimTreeToggle", "NvimTreeFindFile"}
            } -- Drawerboard style like nerdtree

            -- movement
            use "unblevable/quick-scope" -- f F t T improved highlight
            use {"ggandor/lightspeed.nvim"} -- lightspeed motion

            -- quality of life
            use {"hkupty/nvimux"} -- tmux in nvim
            use {"lambdalisue/suda.vim", cmd = {"SudaWrite"}} -- save as root
            use "folke/which-key.nvim" -- which key
            use "junegunn/vim-slash" -- better search
            use "windwp/nvim-autopairs" -- autopairs "" {}
            use {"alvan/vim-closetag", ft = {"html", "jsx", "tsx", "xhtml", "xml"}} -- close <> tag for xhtml ... maybe remove because of TS tag
            use "tpope/vim-surround" -- surround "" ''
            use {"vimwiki/vimwiki", cmd = {"VimwikiIndex", "VimwikiDiaryIndex", "VimwikiMakeDiaryNote"}}
            use {
                "kristijanhusak/orgmode.nvim",
                config = function()
                    require("orgmode").setup {
                        org_agenda_files = {"~/org/*"},
                        org_default_notes_file = "~/org/refile.org"
                    }
                end
            }
            use {
                "kdav5758/HighStr.nvim",
                opt = true,
                cmd = {"HSHighlight", "HSRmHighlight"},
                config = function()
                    local high_str = require("high-str")
                    high_str.setup(
                        {
                            verbosity = 0,
                            highlight_colors = {
                                -- color_id = {"bg_hex_code",<"fg_hex_code"/"smart">}
                                color_0 = {"#000000", "smart"}, -- Chartreuse yellow
                                color_1 = {"#e5c07b", "smart"}, -- Pastel yellow
                                color_2 = {"#7FFFD4", "smart"}, -- Aqua menthe
                                color_3 = {"#8A2BE2", "smart"}, -- Proton purple
                                color_4 = {"#FF4500", "smart"}, -- Orange red
                                color_5 = {"#008000", "smart"}, -- Office green
                                color_6 = {"#0000FF", "smart"}, -- Just blue
                                color_7 = {"#FFC0CB", "smart"}, -- Blush pink
                                color_8 = {"#FFF9E3", "smart"}, -- Cosmic latte
                                color_9 = {"#7d5c34", "smart"} -- Fallow brown
                            }
                        }
                    )
                end
            }

            -- misc
            use {"windwp/nvim-projectconfig", disable = true} -- project dependable cfg
            use {
                "famiu/nvim-reload",
                cmd = {"Reload", "Restart"},
                config = function()
                    vim.cmd [[packadd plenary.nvim]]
                end
            } -- reload nvim config
            use {
                "glepnir/dashboard-nvim",
                config = function()
                    require("plugins.dashboard")
                end
            } -- dashboard
            use {
                "lukas-reineke/indent-blankline.nvim",
                event = "BufRead"
            } -- show indentation

            -- git
            use {
                "pwntester/octo.nvim",
                requires = {"nvim-telescope/telescope.nvim"},
                after = "telescope.nvim"
            }
            use {
                "ruifm/gitlinker.nvim",
                opt = true
            } -- get repo file on remote as url
            use {
                "lewis6991/gitsigns.nvim",
                event = {"BufRead", "BufNewFile"},
                config = function()
                    require("plugins.gitsigns")
                end,
                requires = {
                    {"nvim-lua/plenary.nvim", after = "gitsigns.nvim"},
                    {"nvim-lua/popup.nvim", after = "gitsigns.nvim"}
                }
            } -- like gitgutter shows hunks etc on sign column
            use {"tpope/vim-fugitive", opt = true, cmd = {"Git", "Gdiff", "Gblame"}} -- git integration

            -- testing / building
            use {
                "vim-test/vim-test",
                cmd = {"TestFile"},
                requires = {
                    {"neomake/neomake", cmd = {"Neomake"}},
                    {"tpope/vim-dispatch", cmd = {"Dispatch"}}
                },
                after = {"vim-dispatch", "neomake"}
            }

            -- debug
            use {
                "mfussenegger/nvim-dap",
                opt = true
            }
            use {"rcarriga/nvim-dap-ui", opt = true, requires = {"mfussenegger/nvim-dap"}}

            -- lib
            use {"wbthomason/packer.nvim", opt = true} -- packer
        end,
        config = {
            compile_path = packer_compiled,
            disable_commands = true,
            git = {clone_timeout = 120}
        }
    }
end

-- bootstrap packer
local function bootstrap()
    local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
    -- check if packer exists or is installed
    if fn.empty(fn.glob(install_path)) > 0 then
        -- fetch packer
        execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
        execute "packadd packer.nvim"

        -- autocmd hook to wait for packer install and then after install load the needed config for plugins
        vim.cmd "autocmd User PackerComplete ++once lua require('load_config')"

        -- load packer plugins
        init()

        -- install packer plugins
        require("packer").sync()
    else
        -- add packer and load plugins and config
        execute "packadd packer.nvim"
        init()
        require("load_config")
    end
end

local plugins =
    setmetatable(
    {},
    {
        __index = function(_, key)
            if not packer then
                init()
            end
            return packer[key]
        end
    }
)

function plugins.ensure_plugins()
    bootstrap()
end

function plugins.convert_compile_file()
    local lines = {}
    local lnum = 1
    lines[#lines + 1] = "vim.cmd [[packadd packer.nvim]]\n"
    for line in io.lines(packer_compiled) do
        lnum = lnum + 1
        if lnum > 15 then
            lines[#lines + 1] = line .. "\n"
            if line == "END" then
                break
            end
        end
    end
    table.remove(lines, #lines)
    if fn.isdirectory(data_path .. "lua") ~= 1 then
        os.execute("mkdir -p " .. data_path .. "lua")
    end
    if fn.filereadable(compile_to_lua) == 1 then
        os.remove(compile_to_lua)
    end
    local file = io.open(compile_to_lua, "w")
    for _, line in ipairs(lines) do
        file:write(line)
    end
    file:close()

    os.remove(packer_compiled)
end

function plugins.auto_compile()
    plugins.compile()
    plugins.convert_compile_file()
end

function plugins.load_compile()
    if fn.filereadable(compile_to_lua) == 1 then
        require("_compiled")
    else
        assert("Missing packer compile file Run PackerCompile Or PackerInstall to fix")
    end

    vim.cmd [[command! PackerCompile lua require('packer-config').auto_compile()]]
    vim.cmd [[command! PackerInstall lua require('packer-config').install()]]
    vim.cmd [[command! PackerUpdate lua require('packer-config').update()]]
    vim.cmd [[command! PackerSync lua require('packer-config').sync()]]
    vim.cmd [[command! PackerClean lua require('packer-config').clean()]]
    vim.cmd [[autocmd User PackerComplete lua require('packer-config').auto_compile()]]
    vim.cmd [[command! PackerStatus  lua require('packer-config').status()]]
end

return plugins
