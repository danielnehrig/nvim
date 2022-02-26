local execute = vim.api.nvim_command
local fn = vim.fn
local global = require("config.core.global")
local vim_path = global.vim_path
local sep_os_replacer = require("config.utils").sep_os_replacer
local packer_compiled = vim_path .. "plugin/" .. "packer_compiled.lua"

-- nil some packer is opt
local packer = nil

local function init()
  packer = require("packer")
  packer.init({
    max_jobs = 50,
    disable_commands = true,
    display = {
      open_fn = require("packer.util").float,
    },
    git = { clone_timeout = 120 },
  })
  packer.reset()
  local use = packer.use

  -- theme
  use({ "lewis6991/impatient.nvim" })
  use({
    "windwp/windline.nvim",
    config = function()
      require("config.plugins.statusline.windline")
    end,
  }) -- Statusline
  use({ "romgrk/barbar.nvim", requires = "kyazdani42/nvim-web-devicons" }) -- Bufferline
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
    "folke/tokyonight.nvim",
    config = function()
      vim.o.background = "dark" -- or light if you so prefer
      vim.g.tokyonight_style = "night"
      vim.g.tokyonight_transparent = not vim.g.neovide and true or false
      vim.g.tokyonight_transparent_sidebar = not vim.g.neovide and true or false

      vim.cmd([[colorscheme tokyonight]])
      require("config.core.highlights")
    end,
  })
  use({
    "Murtaza-Udaipurwala/gruvqueen",
    disable = true,
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
      require("config.core.highlights")
    end,
  }) -- Color scheme

  -- language
  use({ "mfussenegger/nvim-jdtls", opt = true })
  use({
    "Saecki/crates.nvim",
    ft = { "toml", "rs" },
    requires = { "nvim-lua/plenary.nvim" },
    config = require("config.plugins.crates").init,
  }) -- rust crates info
  use({
    "danielnehrig/github-ci.nvim",
    requires = { "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
    cmd = { "GithubCI" },
    config = function()
      vim.cmd([[packadd nvim-notify]])
      require("githubci").setup()
    end,
  })
  use({
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
    ft = { "json" },
    config = function()
      require("package-info").setup()
    end,
  }) -- package.json info
  use({ "folke/lua-dev.nvim", opt = true }) -- lua nvim setup
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
  use({ "yioneko/nvim-yati", requires = "nvim-treesitter/nvim-treesitter" })
  use({
    "danymat/neogen",
    cmd = { "DocGen" },
    config = require("config.plugins.neogen").init,
    requires = "nvim-treesitter/nvim-treesitter",
  })
  use({ "JoosepAlviste/nvim-ts-context-commentstring" }) -- comment out code
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
    config = function()
      require("spellsitter").setup({ enable = true, captures = { "comment" } })
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
  use({ "ray-x/lsp_signature.nvim", opt = true, disable = true }) -- auto signature trigger
  use({ "hrsh7th/cmp-nvim-lsp-signature-help" }) -- auto signature trigger
  use({
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
    end,
    cmd = { "Trouble" },
    requires = "kyazdani42/nvim-web-devicons",
  }) -- window for showing LSP detected issues in code
  use({
    "folke/todo-comments.nvim",
    config = require("config.plugins.todo").init,
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
        mode = "symbol_text",
        -- default: true

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
    config = require("config.plugins.lspconfig").init,
    requires = {
      "nvim-lua/lsp-status.nvim",
      after = { "neovim/nvim-lspconfig" },
    },
  }) -- default configs for lsp and setup lsp
  use({
    "tzachar/cmp-tabnine",
    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
  })
  use({
    "hrsh7th/nvim-cmp",
    config = require("config.plugins.cmp").init,
    branch = "dev",
    requires = {
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "f3fora/cmp-spell" },
      -- { "f3fora/cmp-nuspell", rocks = { "lua-nuspell" } },
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
    "ahmedkhalf/Project.nvim",
    disable = true,
    config = function()
      require("project_nvim").setup()
    end,
  })
  use({
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    config = require("config.plugins.telescope").init,
    requires = {
      { "nvim-lua/plenary.nvim", opt = true },
      { "nvim-telescope/telescope-file-browser.nvim", opt = true },
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
    config = require("config.plugins.nvimTree").init,
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
  }) -- Drawerboard style like nerdtree

  -- movement
  use({ "ggandor/lightspeed.nvim", keys = { "s", "S", "t", "f", "T", "F" } })
  use({
    "abecodes/tabout.nvim",
    config = function()
      require("tabout").setup({
        tabkey = "<Tab>",
        backwards_tabkey = "<S-Tab>",
        act_as_tab = true,
        act_as_shift_tab = false,
        enable_backwards = true,
        completion = true,
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true,
        exclude = {},
      })
    end,
    wants = { "nvim-treesitter" },
    after = { "nvim-cmp" },
  })

  -- quality of life
  use({
    "p00f/cphelper.nvim",
  })
  use({
    "anuvyklack/pretty-fold.nvim",
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
      require("pretty-fold.preview").setup({ border = "rounded" })
    end,
  })
  use({
    "andweeb/presence.nvim",
    config = function()
      require("presence"):setup({
        -- General options
        auto_update = true,
        neovim_image_text = "The One True Text Editor",
        main_image = "neovim",
        client_id = "793271441293967371",
        log_level = nil,
        debounce_timeout = 10,
        enable_line_number = false,
        blacklist = {},
        buttons = true,

        -- Rich Presence text options
        editing_text = "Editing %s",
        file_explorer_text = "Browsing %s",
        git_commit_text = "Committing changes",
        plugin_manager_text = "Managing plugins",
        reading_text = "Reading %s",
        workspace_text = "Working on %s",
        line_number_text = "Line %s out of %s",
      })
    end,
  })
  use({
    "VonHeikemen/fine-cmdline.nvim",
    config = function()
      local fineline = require("fine-cmdline")
      local fno = fineline.fn

      fineline.setup({
        cmdline = {
          -- Prompt can influence the completion engine.
          -- Change it to something that works for you
          prompt = ": ",

          -- Let the user handle the keybindings
          enable_keymaps = false,
        },
        popup = {
          buf_options = {
            -- Setup a special file type if you need to
            filetype = "fineline",
          },
        },
        hooks = {
          set_keymaps = function(imap, _)
            -- Restore default keybindings...
            -- Except for `<Tab>`, that's what everyone uses to autocomplete
            imap("<Esc>", fno.close)
            imap("<C-c>", fno.close)

            imap("<Up>", fno.up_search_history)
            imap("<Down>", fno.down_search_history)
          end,
        },
      })
    end,
    requires = {
      { "MunifTanjim/nui.nvim" },
    },
  })
  use({ "junegunn/vim-easy-align", cmd = { "EasyAlign" } })
  use({ "nathom/filetype.nvim" })
  use({
    "luukvbaal/stabilize.nvim",
    config = function()
      require("stabilize").setup({
        force = true, -- stabilize window even when current cursor position will be hidden behind new window
        forcemark = nil, -- set context mark to register on force event which can be jumped to with '<forcemark>
        ignore = { -- do not manage windows matching these file/buftypes
          filetype = { "packer", "Dashboard", "Trouble", "TelescopePrompt" },
          buftype = {
            "packer",
            "Dashboard",
            "terminal",
            "quickfix",
            "loclist",
          },
        },
        nested = nil, -- comma-separated list of autocmds that wil trigger the plugins window restore function
      })
    end,
  })
  use({
    "tanvirtin/vgit.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("vgit").setup({
        settings = {
          live_gutter = {
            enabled = false,
          },
        },
      })
    end,
  })
  use({
    "rlch/github-notifications.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = require("config.plugins.gh").init,
  })
  use({
    "rmagatti/auto-session",
    disable = true,
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
  use({ "Xuyuanp/scrollbar.nvim", disable = true })
  use({
    "t9md/vim-choosewin",
    cmd = { "ChooseWin" },
  })
  use({ "kevinhwang91/nvim-bqf", ft = "qf" }) -- better quickfix
  use({
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        -- Animation style (see below for details)
        -- stages = "fade",
        -- Default timeout for notifications
        timeout = 3000,
        -- For stages that change opacity this is treated as the highlight behind the window
        background_colour = "NotifyBG",
        -- Icons for the different levels
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      })
      vim.notify = notify
    end,
    opt = true,
  }) -- notication pop up
  use({
    "ThePrimeagen/refactoring.nvim",
    config = require("config.plugins.refactoring").init,
    opt = true,
    requires = {
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-lua/plenary.nvim", opt = true },
    },
  }) -- refactoring
  use({
    "hkupty/nvimux",
    keys = { "<C-a>" },
    config = require("config.plugins.nvimux").init,
  }) -- tmux in nvim
  use({ "lambdalisue/suda.vim", cmd = { "SudaWrite" } }) -- save as root
  use({ "junegunn/vim-slash", keys = { "/" } }) -- better search
  use({ "windwp/nvim-autopairs" }) -- autopairs "" {}
  use({
    "alvan/vim-closetag",
    ft = { "html", "jsx", "tsx", "xhtml", "xml" },
  }) -- close <> tag for xhtml ... maybe remove because of TS tag
  use({
    "blackCauldron7/surround.nvim",
    disable = true,
    config = function()
      require("surround").setup({ mappings_style = "surround" })
    end,
  })
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
        saving_path = "~/highstr/",
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
    setup = require("config.plugins.dashboard").dashboard,
  }) -- dashboard
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = require("config.plugins.indent-blankline").init,
    event = "BufRead",
  }) -- show indentation

  -- git
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
    config = require("config.plugins.gitsigns").init,
    requires = {
      { "nvim-lua/plenary.nvim", after = "gitsigns.nvim" },
    },
  }) -- like gitgutter shows hunks etc on sign column
  use({
    "tpope/vim-fugitive",
    disable = true,
    cmd = { "Git", "Git mergetool" },
  }) -- git integration
  use({
    "TimUntersberger/neogit",
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        disable_signs = true,
        disable_hint = false,
      })
    end,
    requires = "nvim-lua/plenary.nvim",
  })

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
        installation_path = sep_os_replacer(
          vim.fn.stdpath("data") .. "/dapinstall/"
        ),
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
  local install_path = sep_os_replacer(
    fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
  )
  -- check if packer exists or is installed
  if fn.empty(fn.glob(install_path)) > 0 then
    -- fetch packer
    execute(
      "!git clone https://github.com/wbthomason/packer.nvim " .. install_path
    )
    execute("packadd packer.nvim")

    -- autocmd hook to wait for packer install and then after install load the needed config for plugins
    vim.cmd(
      "autocmd User PackerComplete ++once lua require('config.load_config').init()"
    )

    -- load packer plugins
    init()

    -- install packer plugins
    require("packer").sync()
  else
    -- add packer and load plugins and config
    execute("packadd packer.nvim")
    init()
    require("config.load_config").init()
  end
end

-- autocompile function called by autocmd on packer complete
function plugins.auto_compile()
  plugins.compile()
end

-- loads the compiled packer file and sets the commands for packer
function plugins.load_compile()
  if not fn.filereadable(packer_compiled) == 1 then
    assert(
      "Missing packer compile file Run PackerCompile Or PackerInstall to fix"
    )
  end

  vim.cmd(
    [[command! PackerCompile lua require('config.packer-config').auto_compile()]]
  )
  vim.cmd(
    [[command! PackerInstall lua require('config.packer-config').install()]]
  )
  vim.cmd(
    [[command! PackerUpdate lua require('config.packer-config').update()]]
  )
  vim.cmd([[command! PackerSync lua require('config.packer-config').sync()]])
  vim.cmd([[command! PackerClean lua require('config.packer-config').clean()]])
  vim.cmd(
    [[command! PackerStatus  lua require('config.packer-config').status()]]
  )
end

return plugins
