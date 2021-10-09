local execute = vim.api.nvim_command
local fn = vim.fn
local global = require("core.global")
local data_path = global.data_path
local packer_compiled = data_path .. "packer_compiled.vim"
local compile_to_lua = data_path .. "lua" .. global.path_sep .. "_compiled.lua"

local is_private = os.getenv("USER") == "dashie"

-- nil because packer is opt
local packer = nil

local function init()
  packer = require("packer")
  packer.init({
    compile_path = packer_compiled,
    disable_commands = true,
    display = {
      open_fn = require("packer.util").float,
    },
    git = { clone_timeout = 120 },
  })
  packer.reset()
  local use = packer.use

  -- theme
  use({
    "windwp/windline.nvim",
    config = function()
      require("plugins.statusline.windline")
    end,
  }) -- statusline
  use({ "romgrk/barbar.nvim", requires = "kyazdani42/nvim-web-devicons" }) -- bufferline
  use({
    "norcalli/nvim-colorizer.lua",
    ft = {
      "css",
      "scss",
      "sass",
      "javascriptreact",
      "typescriptreact",
      "lua",
    },
    config = function()
      require("colorizer").setup()
    end,
  }) -- colors hex
  use({
    "Murtaza-Udaipurwala/gruvqueen",
    config = function()
      vim.o.background = "dark" -- or light if you so prefer
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

      vim.cmd([[colorscheme gruvqueen]])
      require("core.highlights")
    end,
  }) -- colorscheme

  -- language
  use({ "mfussenegger/nvim-jdtls", opt = true })
  use({
    "Saecki/crates.nvim",
    ft = { "toml", "rs" },
    requires = { "nvim-lua/plenary.nvim" },
    config = require("plugins.crates").init,
  }) -- rust crates info
  use({
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
    ft = { "json" },
    config = function()
      require("package-info").setup()
    end,
  }) -- package.json info
  use({ "danielnehrig/lua-dev.nvim", branch = "nvim_workspace", opt = true }) -- lua nvim setup
  use({ "rust-lang/rust.vim", ft = { "rust", "rs" } }) -- rust language tools
  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    ft = { "markdown", "md" },
    cmd = "MarkdownPreview",
  }) -- markdown previewer
  use({
    "metakirby5/codi.vim",
    cmd = { "Codi" },
    ft = { "javascript", "typescript", "lua" },
  }) -- code playground in buffer executed
  use({ "nvim-treesitter/nvim-treesitter" }) -- syntax highlight indent etc
  use({
    "danymat/neogen",
    cmd = { "DocGen" },
    config = require("plugins.neogen").init,
    requires = "nvim-treesitter/nvim-treesitter",
  })
  use({ "JoosepAlviste/nvim-ts-context-commentstring" }) -- coment out code
  use({
    "winston0410/commented.nvim",
    keys = { "<space>cc" },
    config = function()
      require("commented").setup({
        hooks = {
          before_comment = require("ts_context_commentstring.internal").update_commentstring,
        },
      })
    end,
  }) -- comment out code
  use({ "nvim-treesitter/nvim-treesitter-textobjects" }) -- custom textobjects
  use({ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" })
  use({ "RRethy/nvim-treesitter-textsubjects" })
  use({
    "lewis6991/spellsitter.nvim",
    disable = true,
    config = function()
      require("spellsitter").setup({ captures = { "comment" } })
    end,
  }) -- spell check treesitter based
  use({
    "windwp/nvim-ts-autotag",
    ft = { "typescriptreact", "javascriptreact", "html" },
  }) -- autotag <>
  use({
    "shuntaka9576/preview-swagger.nvim",
    run = "yarn install",
    ft = { "yaml", "yml" },
    cmd = "SwaggerPreview",
  }) -- openapi preview

  -- completion
  use({ "ray-x/lsp_signature.nvim", opt = true }) -- auto signature trigger
  use({
    "folke/lsp-trouble.nvim",
    config = function()
      require("trouble").setup()
    end,
    cmd = { "LspTrouble" },
    requires = "kyazdani42/nvim-web-devicons",
  }) -- window for showing LSP detected issues in code
  use({
    "folke/todo-comments.nvim",
    config = require("plugins.todo").init,
    wants = "telescope.nvim",
    cmd = { "TodoQuickFix", "TodoTrouble", "TodoTelescope" },
  }) -- show todos in qf
  use({
    "nvim-lua/lsp-status.nvim",
  }) -- lsp status
  use({
    "onsails/lspkind-nvim",
    config = function()
      require("lspkind").init({
        -- enables text annotations
        --
        -- default: true
        with_text = true,

        -- default symbol map
        -- can be either 'default' (requires nerd-fonts font) or
        -- 'codicons' for codicon preset (requires vscode-codicons font)
        --
        -- default: 'default'
        preset = "codicons",

        -- override preset symbols
        --
        -- default: {}
        symbol_map = {
          Text = "",
          Method = "",
          Function = "",
          Constructor = "",
          Field = "ﰠ",
          Variable = "",
          Class = "ﴯ",
          Interface = "",
          Module = "",
          Property = "ﰠ",
          Unit = "塞",
          Value = "",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "פּ",
          Event = "",
          Operator = "",
          TypeParameter = "",
        },
      })
    end,
  }) -- lsp extensions stuff
  use({
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    keys = { "<space>gf" },
  }) -- code actions menu
  use({
    "jghauser/mkdir.nvim",
    config = function()
      require("mkdir")
    end,
  }) -- create folders if not existing
  use({
    "folke/lsp-colors.nvim",
    config = function()
      require("lsp-colors").setup({
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981",
      })
    end,
  }) -- lsp diag colors
  use({
    "neovim/nvim-lspconfig",
    config = require("plugins.lspconfig").init,
    requires = {
      "nvim-lua/lsp-status.nvim",
      after = { "neovim/nvim-lspconfig" },
    },
  }) -- default configs for lsp and setup lsp
  use({
    "hrsh7th/nvim-cmp",
    config = require("plugins.cmp").init,
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
      {
        "kristijanhusak/orgmode.nvim",
        config = function()
          require("orgmode").setup({
            org_agenda_files = { "~/org/*" },
            org_default_notes_file = "~/org/refile.org",
          })
        end,
        keys = { "<space>oc", "<space>oa" },
        ft = { "org" },
        wants = "nvim-cmp",
      },
    },
  }) -- cmp completion engine

  -- navigation
  use({
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope", "Octo" },
    config = require("plugins.telescope").init,
    requires = {
      { "nvim-lua/plenary.nvim", opt = true },
      { "nvim-telescope/telescope-project.nvim", opt = true },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        opt = true,
        run = "make",
      },
    },
  }) -- fuzzy finder
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("nvim-tree").setup({})
    end,
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
  }) -- Drawerboard style like nerdtree

  -- movement
  use({ "ggandor/lightspeed.nvim", keys = { "s", "S", "t", "f", "T", "F" } }) -- lightspeed motion

  -- quality of life
  use({
    "rmagatti/auto-session",
    config = function()
      local opts = {
        log_level = "info",
        auto_session_enable_last_session = false,
        auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
        auto_session_enabled = true,
        auto_save_enabled = nil,
        auto_restore_enabled = false,
        auto_session_suppress_dirs = nil,
      }

      require("auto-session").setup(opts)
    end,
  })
  use({ "Xuyuanp/scrollbar.nvim" })
  use({ "wakatime/vim-wakatime", disable = not is_private }) -- time tracking
  use({
    "t9md/vim-choosewin",
    cmd = { "ChooseWin" },
  })
  use({ "kevinhwang91/nvim-bqf" }) -- better quickfix
  use({
    "gelguy/wilder.nvim",
    opt = true,
  }) -- better wild menu
  use({
    "rcarriga/nvim-notify",
    opt = true,
  }) -- notication pop up
  use({
    "ThePrimeagen/refactoring.nvim",
    config = require("plugins.refactoring").init,
    opt = true,
    requires = {
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-lua/plenary.nvim", opt = true },
    },
  }) -- refactoring
  use({
    "hkupty/nvimux",
    keys = { "<C-a>" },
    config = require("plugins.nvimux").init,
  }) -- tmux in nvim
  use({ "lambdalisue/suda.vim", cmd = { "SudaWrite" } }) -- save as root
  use({ "junegunn/vim-slash", keys = { "/" } }) -- better search
  use({ "windwp/nvim-autopairs" }) -- autopairs "" {}
  use({
    "alvan/vim-closetag",
    ft = { "html", "jsx", "tsx", "xhtml", "xml" },
  }) -- close <> tag for xhtml ... maybe remove because of TS tag
  use({ "tpope/vim-surround" }) -- surround "" ''
  use({
    "vimwiki/vimwiki",
    cmd = { "VimwikiIndex", "VimwikiDiaryIndex", "VimwikiMakeDiaryNote" },
  }) -- wiki
  use({
    "kdav5758/HighStr.nvim",
    opt = true,
    cmd = { "HSHighlight", "HSRmHighlight" },
    config = function()
      local high_str = require("high-str")
      high_str.setup({
        verbosity = 0,
        highlight_colors = {
          -- color_id = {"bg_hex_code",<"fg_hex_code"/"smart">}
          color_0 = { "#000000", "smart" }, -- Chartreuse yellow
          color_1 = { "#e5c07b", "smart" }, -- Pastel yellow
          color_2 = { "#7FFFD4", "smart" }, -- Aqua menthe
          color_3 = { "#8A2BE2", "smart" }, -- Proton purple
          color_4 = { "#FF4500", "smart" }, -- Orange red
          color_5 = { "#008000", "smart" }, -- Office green
          color_6 = { "#0000FF", "smart" }, -- Just blue
          color_7 = { "#FFC0CB", "smart" }, -- Blush pink
          color_8 = { "#FFF9E3", "smart" }, -- Cosmic latte
          color_9 = { "#7d5c34", "smart" }, -- Fallow brown
        },
      })
    end,
  }) -- highlight regions

  -- misc
  use({ "windwp/nvim-projectconfig", disable = true }) -- project dependable cfg
  use({
    "glepnir/dashboard-nvim",
    setup = require("plugins.dashboard").dashboard,
  }) -- dashboard
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = require("plugins.indent-blankline").init,
    event = "BufRead",
  }) -- show indentation

  -- git
  use({
    "tanvirtin/vgit.nvim",
    cmd = { "VGit" },
    commit = "c1e5c82f5fc73bddb32eaef411dcc5e36ebc4efc",
    config = require("plugins.vgit").init,
    requires = {
      "nvim-lua/plenary.nvim",
    },
  }) -- visual git
  use({
    "pwntester/octo.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    after = "telescope.nvim",
  }) -- octo github pr review issues pr etc
  use({
    "ruifm/gitlinker.nvim",
    requires = {
      { "nvim-lua/plenary.nvim", opt = true },
    },
    opt = true,
  }) -- get repo file on remote as url
  use({
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    config = require("plugins.gitsigns").init,
    requires = {
      { "nvim-lua/plenary.nvim", after = "gitsigns.nvim" },
    },
  }) -- like gitgutter shows hunks etc on sign column
  use({
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiff", "Gblame", "Glog", "Git mergetool" },
  }) -- git integration

  -- testing / building
  use({
    "rcarriga/vim-ultest",
    cmd = { "Ultest" },
    requires = { "vim-test/vim-test" },
    run = ":UpdateRemotePlugins",
  }) -- testing
  use({
    "vim-test/vim-test",
    cmd = { "TestFile" },
    requires = {
      {
        "neomake/neomake",
        cmd = { "Neomake" },
      },
      { "tpope/vim-dispatch", cmd = { "Dispatch" } },
    },
    wants = { "vim-dispatch", "neomake" },
  }) -- testing

  -- debug
  use({ "jbyuki/one-small-step-for-vimkind" }) -- lua debug
  use({ "mfussenegger/nvim-dap-python", opt = true }) -- python debug
  use({
    "Pocco81/DAPInstall.nvim",
    cmd = { "DIInstall", "DIList" },
    config = function()
      local dap_install = require("dap-install")

      dap_install.setup({
        installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
      })
    end,
  }) -- install dap adapters
  use({
    "mfussenegger/nvim-dap",
    opt = true,
  }) -- dap
  use({
    "rcarriga/nvim-dap-ui",
    opt = true,
    requires = { "mfussenegger/nvim-dap" },
  }) -- dap ui

  -- lib
  use({ "wbthomason/packer.nvim", opt = true }) -- packer
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    if not packer then
      init()
    end
    return packer[key]
  end,
})

-- Bootstrap Packer and the Plugins + loads configs afterwards
function plugins.bootstrap()
  local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
  -- check if packer exists or is installed
  if fn.empty(fn.glob(install_path)) > 0 then
    -- fetch packer
    execute(
      "!git clone https://github.com/wbthomason/packer.nvim " .. install_path
    )
    execute("packadd packer.nvim")

    -- autocmd hook to wait for packer install and then after install load the needed config for plugins
    vim.cmd(
      "autocmd User PackerComplete ++once lua require('load_config').init()"
    )

    -- load packer plugins
    init()

    -- install packer plugins
    require("packer").sync()
  else
    -- add packer and load plugins and config
    execute("packadd packer.nvim")
    init()
    require("load_config").init()
  end
end

-- converts the compiled file to lua
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

-- autocompile function called by autocmd on packer complete
function plugins.auto_compile()
  plugins.compile()
  plugins.convert_compile_file()
end

-- loads the compiled packer file and sets the commands for packer
function plugins.load_compile()
  if fn.filereadable(compile_to_lua) == 1 then
    require("_compiled")
  else
    assert(
      "Missing packer compile file Run PackerCompile Or PackerInstall to fix"
    )
  end

  vim.cmd(
    [[command! PackerCompile lua require('packer-config').auto_compile()]]
  )
  vim.cmd([[command! PackerInstall lua require('packer-config').install()]])
  vim.cmd([[command! PackerUpdate lua require('packer-config').update()]])
  vim.cmd([[command! PackerSync lua require('packer-config').sync()]])
  vim.cmd([[command! PackerClean lua require('packer-config').clean()]])
  vim.cmd([[command! PackerStatus  lua require('packer-config').status()]])

  -- autocompile event
  vim.cmd(
    [[autocmd User PackerComplete lua require('packer-config').auto_compile()]]
  )
end

return plugins
