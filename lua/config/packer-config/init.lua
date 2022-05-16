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
    use({ "lewis6991/impatient.nvim" })

    for _, theme in pairs(require("config.packer-config.modules.themes").theme) do
      use(theme)
    end

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

    for _, language in
      pairs(require("config.packer-config.modules.language").language)
    do
      use(language)
    end

    for _, debug in pairs(require("config.packer-config.modules.debug").debug) do
      use(debug)
    end

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
    })
    use({
      "kyazdani42/nvim-tree.lua",
      requires = "kyazdani42/nvim-web-devicons",
      config = require("config.plugins.nvimTree").init,
      cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    })

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
            prompt = ": ",
            enable_keymaps = false,
          },
          popup = {
            buf_options = {
              filetype = "fineline",
            },
          },
          hooks = {
            set_keymaps = function(imap, _)
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
    })
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
    })

    use({
      "glepnir/dashboard-nvim",
      setup = require("config.plugins.dashboard").dashboard,
    })
    use({
      "lukas-reineke/indent-blankline.nvim",
      config = require("config.plugins.indent-blankline").init,
      event = "BufRead",
    })

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
