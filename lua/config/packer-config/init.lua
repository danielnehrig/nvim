local execute = vim.api.nvim_command
local fn = vim.fn
local global = require("config.core.global")
local vim_path = global.vim_path
local sep_os_replacer = require("config.utils").sep_os_replacer
local packer_compiled = vim_path .. "plugin/" .. "packer_compiled.lua"

local function init()
  local packer = require("packer")
  packer.reset()

  packer.startup(function(use)
    -- theme
    use({ "lewis6991/impatient.nvim" })
    use({
      "windwp/windline.nvim",
    }) -- Statusline
    use({ "romgrk/barbar.nvim", requires = "kyazdani42/nvim-web-devicons" })
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

    for _, theme in
      pairs(require("config.packer-config.modules.themes").ts_themes)
    do
      use(theme.packer_cfg)
    end

    for _, utility in
      pairs(require("config.packer-config.modules.utility").utility)
    do
      use(utility)
    end

    for _, git in pairs(require("config.packer-config.modules.git").git) do
      use(git)
    end

    for _, ts in pairs(require("config.packer-config.modules.treesitter").ts) do
      use(ts)
    end

    for _, lsp in pairs(require("config.packer-config.modules.lsp").lsp) do
      use(lsp)
    end

    for _, completion in
      pairs(require("config.packer-config.modules.completion").completion)
    do
      use(completion)
    end

    -- language
    use({ "mfussenegger/nvim-jdtls", opt = true })
    use({
      "Saecki/crates.nvim",
      ft = { "toml", "rs" },
      requires = { "nvim-lua/plenary.nvim" },
      config = require("config.plugins.crates").init,
    })

    use({
      "vuki656/package-info.nvim",
      requires = "MunifTanjim/nui.nvim",
      ft = { "json" },
      config = function()
        require("package-info").setup()
      end,
    }) -- package.json info
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
    use({
      "shuntaka9576/preview-swagger.nvim",
      run = "yarn install",
      ft = { "yaml", "yml" },
      cmd = "SwaggerPreview",
    }) -- openapi preview

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
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-file-browser.nvim", opt = true },
        { "nvim-telescope/telescope-project.nvim", opt = true },
      },
    }) -- fuzzy finder
    use({
      "kyazdani42/nvim-tree.lua",
      requires = "kyazdani42/nvim-web-devicons",
      config = require("config.plugins.nvimTree").init,
      cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    }) -- Drawerboard style like nerdtree

    -- movement
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
    use({ "nvim-lua/plenary.nvim" })
    use({
      "ThePrimeagen/refactoring.nvim",
      config = require("config.plugins.refactoring").init,
      requires = {
        { "nvim-treesitter/nvim-treesitter" },
        { "nvim-lua/plenary.nvim" },
      },
    }) -- refactoring
    use({
      "hkupty/nvimux",
      keys = { "<C-a>" },
      config = require("config.plugins.nvimux").init,
    }) -- tmux in nvim
    use({ "windwp/nvim-autopairs" }) -- autopairs "" {}
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
  end)
end

local plugins = {}
plugins._index = plugins

-- Bootstrap Packer and the Plugins + loads configs afterwards
function plugins.bootstrap()
  local install_path = sep_os_replacer(
    fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
  )
  -- check if packer exists or is installed
  if fn.empty(fn.glob(install_path)) > 0 then
    -- fetch packer
    vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
    execute("packadd packer.nvim")
    local packer = require("packer")

    -- load packer plugins
    init()

    -- install packer plugins
    packer.sync()
  else
    -- add packer and load plugins and config
    execute("packadd packer.nvim")
    init()
    require("config.load_config").init()
  end
end

-- loads the compiled packer file and sets the commands for packer
function plugins.load_compile()
  if fn.filereadable(packer_compiled) ~= 1 then
    assert(
      "Missing packer compile file Run PackerCompile Or PackerInstall to fix"
    )
  end
  local packer = require("packer")
  packer.make_commands()
end

return plugins
