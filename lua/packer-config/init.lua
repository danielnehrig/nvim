local execute = vim.api.nvim_command
local fn = vim.fn
local global = require("core.global")
local data_path = global.data_path
local packer_compiled = data_path .. "packer_compiled.vim"
local compile_to_lua = data_path .. "lua" .. global.path_sep .. "_compiled.lua"

-- bootstrap packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute "packadd packer.nvim"
end

local packer = nil
local function init()
    if not packer then
        execute("packadd packer.nvim")
        packer = require("packer")
    end
    packer.init(
        {
            compile_path = packer_compiled,
            disable_commands = true,
            git = {clone_timeout = 120}
        }
    )
    packer.reset()
    local use = packer.use

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
    use {"jose-elias-alvarez/nvim-lsp-ts-utils", opt = true, ft = {"typescriptreact", "typescript"}} -- eslint code actions
    use {"rust-lang/rust.vim", opt = true, ft = {"rust", "rs"}} -- rust language tools
    use {"simrat39/rust-tools.nvim", disable = true} -- rust language tools
    use {
        "iamcco/markdown-preview.nvim",
        run = "cd app && yarn install",
        opt = true,
        ft = {"markdown", "md"},
        cmd = "MarkdownPreview"
    } -- markdown previewer
    use {"metakirby5/codi.vim", cmd = {"Codi"}, ft = {"js", "ts", "lua", "typescript", "javascript"}} -- code playground in buffer executed
    use "nvim-treesitter/nvim-treesitter" -- syntax highlight indent etc
    use "nvim-treesitter/nvim-treesitter-textobjects" -- custom textobjects
    use {"windwp/nvim-ts-autotag", opt = true, ft = {"tsx", "typescriptreact", "jsx", "html"}} -- autotag <>
    use {
        "shuntaka9576/preview-swagger.nvim",
        opt = true,
        run = "yarn install",
        ft = {"yaml", "yml"},
        cmd = "SwaggerPreview"
    } -- openapi preview

    -- snip
    use "norcalli/snippets.nvim" -- snippets

    -- completion
    use {"ray-x/lsp_signature.nvim", opt = true} -- auto signature trigger
    use {"RRethy/vim-illuminate", opt = true}
    use {"ray-x/navigator.lua", requires = {"ray-x/guihua.lua", run = "cd lua/fzy && make"}}
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
    use "nvim-lua/lsp-status.nvim" -- lsp status
    use "glepnir/lspsaga.nvim" -- fancy popups lsp
    use "onsails/lspkind-nvim" -- lsp extensions stuff
    use {"nvim-lua/lsp_extensions.nvim", disable = true} -- lsp extensions inlay hints etc
    use "neovim/nvim-lspconfig" -- default configs for lsp and setup lsp
    use {
        "hrsh7th/nvim-compe",
        event = "InsertEnter",
        config = function()
            require("plugins.lspconfig").compe()
        end
    } -- completion engine

    -- navigation
    use {
        "nvim-telescope/telescope.nvim",
        opt = true,
        cmd = {"Telescope", "Octo"},
        config = function()
            require("plugins.telescope")()
        end,
        requires = {
            {"nvim-lua/popup.nvim", opt = true},
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
    use "unblevable/quick-scope" -- f F t T improved highlight
    use {"ggandor/lightspeed.nvim"} -- lightspeed motion

    -- quality of life
    use {"hkupty/nvimux"} -- tmux in nvim
    use {"lambdalisue/suda.vim", cmd = {"SudaWrite"}} -- save as root
    use "danilamihailov/beacon.nvim" -- jump indicator
    use "folke/which-key.nvim" -- which key
    use "preservim/nerdcommenter" -- commenting
    use "junegunn/vim-slash" -- better search
    use "windwp/nvim-autopairs" -- autopairs "" {}
    use {"alvan/vim-closetag", opt = true, ft = {"html", "jsx", "tsx", "xhtml", "xml"}} -- close <> tag for xhtml ... maybe remove because of TS tag
    use "tpope/vim-surround" -- surround "" ''
    use {"vimwiki/vimwiki", opt = true, cmd = {"VimwikiIndex", "VimwikiDiaryIndex", "VimwikiMakeDiaryNote"}}
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
        opt = true,
        cmd = {"Reload", "Restart"},
        config = function()
            vim.cmd [[packadd plenary.nvim]]
        end
    } -- reload nvim config
    use "glepnir/dashboard-nvim" -- dashboard
    use {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        branch = "lua"
    } -- show indentation

    -- git
    use {
        "pwntester/octo.nvim",
        opt = true
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
        requires = {{"nvim-lua/plenary.nvim", opt = true}, {"nvim-lua/popup.nvim", opt = true}}
    } -- like gitgutter shows hunks etc on sign column
    use {"tpope/vim-fugitive", opt = true, cmd = {"Git", "Gdiff", "Gblame"}} -- git integration

    -- testing / building
    use {
        "vim-test/vim-test",
        opt = true,
        cmd = {"TestFile"},
        requires = {
            {"neomake/neomake", opt = true, cmd = {"Neomake"}},
            {"tpope/vim-dispatch", opt = true, cmd = {"Dispatch"}}
        }
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

function plugins.ensure_plugins()
    init()
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
end

-- put outside of load compile so packer install can still be triggered
-- if config fails to load properly because of who knows what
vim.cmd [[command! PackerCompile lua require('packer-config').auto_compile()]]
vim.cmd [[command! PackerInstall lua require('packer-config').install()]]
vim.cmd [[command! PackerUpdate lua require('packer-config').update()]]
vim.cmd [[command! PackerSync lua require('packer-config').sync()]]
vim.cmd [[command! PackerClean lua require('packer-config').clean()]]
vim.cmd [[autocmd User PackerComplete lua require('packer-config').auto_compile()]]
vim.cmd [[command! PackerStatus  lua require('packer-config').status()]]

return plugins
