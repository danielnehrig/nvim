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
            display = {
                open_fn = require("packer.util").float
            },
            git = {clone_timeout = 120}
        }
    )
    packer.reset()
    local use = packer.use

    -- theme
    -- use {"glepnir/galaxyline.nvim", branch = "main", requires = "kyazdani42/nvim-web-devicons"} -- statusbar
    use {
        "windwp/windline.nvim",
        config = function()
            require("plugins.statusline.windline")
        end
    }
    use {"romgrk/barbar.nvim", requires = "kyazdani42/nvim-web-devicons"} -- bufferline
    use {
        "norcalli/nvim-colorizer.lua",
        ft = {"css", "scss", "sass", "javascriptreact", "typescriptreact", "lua"},
        config = function()
            require("colorizer").setup()
        end
    } -- colors hex
    use {
        "Murtaza-Udaipurwala/gruvqueen",
        config = function()
            if not vim.g.neovide then
                vim.g.gruvqueen_transparent_background = true
            else
                vim.g.gruvqueen_transparent_background = false
            end
            vim.g.gruvqueen_background_color = "#10151a"
            vim.g.gruvqueen_italic_comments = true
            vim.g.gruvqueen_italic_keywords = true
            vim.g.gruvqueen_italic_functions = true
            vim.g.gruvqueen_italic_variables = true
            vim.g.gruvqueen_invert_selection = true
            vim.g.gruvqueen_style = "mix" -- possible values: 'original', 'mix', 'material'

            vim.cmd("colorscheme gruvqueen")
            require("core.highlights")
        end
    } -- colorscheme

    -- language
    use {"folke/lua-dev.nvim"} -- lua nvim setup
    use {"rust-lang/rust.vim", ft = {"rust", "rs"}} -- rust language tools
    use {
        "iamcco/markdown-preview.nvim",
        run = "cd app && yarn install",
        ft = {"markdown", "md"},
        cmd = "MarkdownPreview"
    } -- markdown previewer
    use {"metakirby5/codi.vim", cmd = {"Codi"}, ft = {"javascript", "typescript", "lua"}} -- code playground in buffer executed
    use {"nvim-treesitter/nvim-treesitter"} -- syntax highlight indent etc
    use {"JoosepAlviste/nvim-ts-context-commentstring"}
    use {
        "winston0410/commented.nvim",
        keys = {"<space>cc"},
        config = function()
            require("commented").setup(
                {
                    hooks = {
                        before_comment = require("ts_context_commentstring.internal").update_commentstring
                    }
                }
            )
        end
    }
    use "nvim-treesitter/nvim-treesitter-textobjects" -- custom textobjects
    use {"nvim-treesitter/playground", cmd = "TSPlaygroundToggle"}
    use "RRethy/nvim-treesitter-textsubjects"
    use {
        "lewis6991/spellsitter.nvim",
        config = function()
            require("spellsitter").setup({captures = {"comment"}})
        end
    }
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
            require("trouble").setup()
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
        wants = "telescope.nvim",
        cmd = {"TodoQuickFix", "TodoTrouble", "TodoTelescope"}
    } -- show todos in qf
    use {
        "nvim-lua/lsp-status.nvim"
    } -- lsp status
    use "glepnir/lspsaga.nvim" -- fancy popups lsp
    use {
        "onsails/lspkind-nvim",
        config = function()
            require("lspkind").init({File = " "})
        end
    } -- lsp extensions stuff
    use {
        "jghauser/mkdir.nvim",
        config = function()
            require("mkdir")
        end
    }
    use {
        "folke/lsp-colors.nvim",
        config = function()
            require("lsp-colors").setup(
                {
                    Error = "#db4b4b",
                    Warning = "#e0af68",
                    Information = "#0db9d7",
                    Hint = "#10B981"
                }
            )
        end
    }
    use {
        "neovim/nvim-lspconfig",
        config = require("plugins.lspconfig").init,
        requires = {"nvim-lua/lsp-status.nvim", after = {"neovim/nvim-lspconfig"}}
    } -- default configs for lsp and setup lsp
    use {
        "hrsh7th/nvim-cmp",
        config = require("plugins.compe").init,
        wants = {"LuaSnip"},
        requires = {
            {"hrsh7th/cmp-nvim-lsp"},
            {"saadparwaiz1/cmp_luasnip"},
            {
                "L3MON4D3/LuaSnip",
                wants = "friendly-snippets",
                event = "InsertCharPre"
            },
            {
                "rafamadriz/friendly-snippets",
                event = "InsertCharPre"
            },
            {
                "kristijanhusak/orgmode.nvim",
                config = function()
                    require("orgmode").setup {
                        org_agenda_files = {"~/org/*"},
                        org_default_notes_file = "~/org/refile.org"
                    }
                end,
                keys = {"<space>oc", "<space>oa"},
                ft = {"org"},
                wants = "nvim-cmp"
            }
        }
    }

    -- navigation
    use {
        "nvim-telescope/telescope.nvim",
        cmd = {"Telescope", "Octo"},
        config = require("plugins.telescope").init,
        requires = {
            {"nvim-lua/plenary.nvim", opt = true},
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
    use {"ggandor/lightspeed.nvim", keys = {"s", "S", "t", "f", "T", "F"}} -- lightspeed motion

    -- quality of life
    use {"kevinhwang91/nvim-bqf"}
    use {
        "gelguy/wilder.nvim"
    }
    use {
        "rcarriga/nvim-notify",
        commit = "2ee19cd937c98d4d40d77ae729c70fe0923a2b8c",
        opt = true
    }
    use {
        "ThePrimeagen/refactoring.nvim",
        config = require("plugins.refactoring").init,
        opt = true,
        requires = {
            {"nvim-treesitter/nvim-treesitter"},
            {"nvim-lua/plenary.nvim", opt = true}
        }
    }
    use {
        "hkupty/nvimux",
        keys = {"<C-a>"},
        config = function()
            require("plugins.nvimux")
        end
    } -- tmux in nvim
    use {"lambdalisue/suda.vim", cmd = {"SudaWrite"}} -- save as root
    use "folke/which-key.nvim" -- which key
    use {"junegunn/vim-slash", keys = {"/"}} -- better search
    use "windwp/nvim-autopairs" -- autopairs "" {}
    use {"alvan/vim-closetag", ft = {"html", "jsx", "tsx", "xhtml", "xml"}} -- close <> tag for xhtml ... maybe remove because of TS tag
    use "tpope/vim-surround" -- surround "" ''
    use {"vimwiki/vimwiki", cmd = {"VimwikiIndex", "VimwikiDiaryIndex", "VimwikiMakeDiaryNote"}}
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
        "glepnir/dashboard-nvim",
        setup = require("plugins.dashboard").dashboard
    } -- dashboard
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = require("plugins.indent-blankline").init,
        event = "BufRead"
    } -- show indentation

    -- git
    use {
        "tanvirtin/vgit.nvim",
        cmd = {"VGit"},
        config = function()
            require("vgit").setup()
        end,
        requires = {
            "nvim-lua/plenary.nvim"
        }
    }
    use {
        "pwntester/octo.nvim",
        requires = {"nvim-telescope/telescope.nvim"},
        after = "telescope.nvim"
    }
    use {
        "ruifm/gitlinker.nvim",
        requires = {
            {"nvim-lua/plenary.nvim", opt = true}
        },
        opt = true
    } -- get repo file on remote as url
    use {
        "lewis6991/gitsigns.nvim",
        event = {"BufRead", "BufNewFile"},
        config = function()
            require("plugins.gitsigns")
        end,
        requires = {
            {"nvim-lua/plenary.nvim", after = "gitsigns.nvim"}
        }
    } -- like gitgutter shows hunks etc on sign column
    use {"tpope/vim-fugitive", opt = true, cmd = {"Git", "Gdiff", "Gblame", "Glog"}} -- git integration

    -- testing / building
    use {"rcarriga/vim-ultest", cmd = {"Ultest"}, wants = {"vim-test"}}
    use {
        "vim-test/vim-test",
        cmd = {"TestFile"},
        requires = {
            {
                "neomake/neomake",
                cmd = {"Neomake"}
            },
            {"tpope/vim-dispatch", cmd = {"Dispatch"}}
        },
        wants = {"vim-dispatch", "neomake"}
    }

    -- debug
    use {
        "mfussenegger/nvim-dap",
        opt = true
    }
    use {"rcarriga/nvim-dap-ui", opt = true, requires = {"mfussenegger/nvim-dap"}}

    -- lib
    use {"wbthomason/packer.nvim", opt = true} -- packer
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

-- Bootstrap Packer and the Plugins
function plugins.bootstrap()
    local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
    -- check if packer exists or is installed
    if fn.empty(fn.glob(install_path)) > 0 then
        -- fetch packer
        execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
        execute "packadd packer.nvim"

        -- autocmd hook to wait for packer install and then after install load the needed config for plugins
        vim.cmd "autocmd User PackerComplete ++once lua require('load_config').init()"

        -- load packer plugins
        init()

        -- install packer plugins
        require("packer").sync()
    else
        -- add packer and load plugins and config
        execute "packadd packer.nvim"
        init()
        require("load_config").init()
    end
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
    vim.cmd [[command! PackerStatus  lua require('packer-config').status()]]

    -- autocompile event
    vim.cmd [[autocmd User PackerComplete lua require('packer-config').auto_compile()]]
end

return plugins
