---@module 'lazy.types'

---@class utility
---@field utility table<string, LazyPluginSpec>
local M = {}
M.utility = {
  -- INFO: center the current buffer nice for widescreen
  ["shortcuts/no-neck-pain.nvim"] = {
    cmd = { "NoNeckPain" },
    version = "*",
  },
  -- INFO: exec async tasks run jobs etc
  ["stevearc/overseer.nvim"] = {
    cmd = { "CompilerOpen", "CompilerToggleResults" },
    opts = {
      -- Tasks are disposed 5 minutes after running to free resources.
      -- If you need to close a task inmediatelly:
      -- press ENTER in the menu you see after compiling on the task you want to close.
      templates = {
        "builtin",
        "user.run_file",
        "user.build_file",
        "user.rust_cov",
      },
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
        bindings = {
          ["q"] = function()
            vim.cmd("OverseerClose")
          end,
        },
      },
    },
  },
  -- INFO: Handles the fancy floating terms for search/commands
  ["folke/noice.nvim"] = {
    event = "VimEnter",
    enabled = function()
      return vim.g.neovide == nil
    end,
    config = function()
      if not vim.g.neovide then
        require("noice").setup({
          presets = {
            -- you can enable a preset by setting it to true, or a table that will override the preset config
            -- you can also add custom presets that you can enable/disable with enabled=true
            bottom_search = false, -- use a classic bottom cmdline for search
            command_palette = false, -- position the cmdline and popupmenu together
            long_message_to_split = false, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
          },
        })
      end
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "hrsh7th/nvim-cmp",
    },
  },
  -- INFO: auto install lsp servers
  ["williamboman/mason.nvim"] = {
    config = function()
      require("mason").setup()
    end,
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
    priority = 53,
  },
  -- INFO: autoinstall lsp servers and configs
  ["williamboman/mason-lspconfig.nvim"] = {
    config = function()
      require("mason-lspconfig").setup()
    end,
    priority = 52,
  },
  -- INFO: depedencie for some plugins
  ["MunifTanjim/nui.nvim"] = { lazy = true },
  -- INFO: lua  nvim framework that is a depedencie for most plugins
  ["nvim-lua/plenary.nvim"] = { lazy = true },
  -- INFO: show coverage info
  ["andythigpen/nvim-coverage"] = {
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("coverage").setup({
        lang = {
          rust = {
            -- grcov cargo install grcov
            coverage_command = table.concat({
              "grcov ./ -s ./ --binary-path ./target/llvm-cov-target/ -t",
              "coveralls --branch --ignore-not-existing --token NO_TOKEN",
            }, " "),
            project_files_only = true,
            project_files = {
              "src/*",
              "tests/*",
              "cortex/src/*",
              "cortex/examples/*",
              "cortex/examples",
              "examples/*",
              "examples",
            },
          },
        },
      })
    end,
  },
  -- INFO: handle autopairs ()
  ["windwp/nvim-autopairs"] = {
    dependencies = "nvim-cmp",
    enabled = true,
    config = function()
      require("config.plugins.configs.autopairs").init()
    end,
  },
  -- vimwiki
  -- INFO: not used anymore (by me)
  ["vimwiki/vimwiki"] = {
    cmd = { "VimwikiIndex", "VimwikiDiaryIndex", "VimwikiMakeDiaryNote" },
  },
  -- shows infos of chained commands
  ["folke/which-key.nvim"] = {
    config = function()
      require("config.plugins.configs.which").init()
    end,
  },
  -- INFO: better normal mode with jj
  ["max397574/better-escape.nvim"] = {
    event = "InsertCharPre",
    config = function()
      require("config.plugins.configs.betterescape").init()
    end,
  },
  -- INFO: show colors of hex codes
  ["norcalli/nvim-colorizer.lua"] = {
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
  },
  -- INFO: show all urls in current buffer
  ["axieax/urlview.nvim"] = {
    cmd = "UrlView",
    config = function()
      require("urlview").setup({
        -- Prompt title (`<context> <default_title>`, e.g. `Buffer Links:`)
        default_title = "Links:",
        -- Default picker to display links with
        -- Options: "default" (vim.ui.select) or "telescope"
        default_picker = "telescope",
        -- Set the default protocol for us to prefix URLs with if they don't start with http/https
        default_prefix = "https://",
        -- Command or method to open links with
        -- Options: "netrw", "system" (default OS browser); or "firefox", "chromium" etc.
        default_action = "system",
        -- Logs user warnings
        log_level_min = vim.log.levels.INFO,
      })
    end,
  },
  -- INFO: write with elevated privilages
  ["lambdalisue/suda.vim"] = { cmd = { "SudaWrite" } }, -- save as root
  -- INFO: better buffer search
  ["junegunn/vim-slash"] = { keys = { "/" } }, -- better search
  -- INFO: handles notifications for instance used by noice
  ["rcarriga/nvim-notify"] = {
    lazy = true,
    config = function()
      local notify = require("notify")
      notify.setup({
        -- Animation style (see below for details)
        -- stages = "fade",
        -- Default timeout for notifications
        timeout = 3000,
        -- For stages that change opacity this is treated as the highlight behind the window
        background_colour = "#000000",
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
  }, -- notication pop up
  -- INFO:  pick your desired window
  ["ten3roberts/window-picker.nvim"] = {
    config = function()
      require("window-picker").setup({
        -- Default keys to annotate, keys will be used in order. The default uses the
        -- most accessible keys from the home row and then top row.
        keys = "alskdjfhgwoeiruty",
        -- Swap windows by holding shift + letter
        swap_shift = true,
        -- Windows containing filetype to exclude
        exclude = { qf = true, NvimTree = true, aerial = true },
        -- Flash the cursor line of the newly focused window for 300ms.
        -- Set to 0 or false to disable.
        flash_duration = 300,
      })
    end,
  },
  -- INFO: better quickfix list shows context for instance of current file
  ["kevinhwang91/nvim-bqf"] = { ft = "qf" }, -- better quickfix
  -- INFO:  another quickfix tool
  ["yorickpeterse/nvim-pqf"] = { event = "VeryLazy", config = true },
  -- INFO: no weird buffer jumping/jitters
  ["luukvbaal/stabilize.nvim"] = {
    config = function()
      require("stabilize").setup({
        force = true,
        forcemark = nil,
        ignore = {
          filetype = { "packer", "Dashboard", "Trouble", "TelescopePrompt" },
          buftype = {
            "packer",
            "Dashboard",
            "terminal",
            "quickfix",
            "loclist",
          },
        },
        nested = nil,
      })
    end,
  },
  -- INFO: discord integration
  ["andweeb/presence.nvim"] = {
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
  },
  -- INFO: s movement motion
  ["ggandor/lightspeed.nvim"] = {},
  -- INFO: create folders if do not exist when in buffer
  ["jghauser/mkdir.nvim"] = {
    config = function()
      require("mkdir")
    end,
  },
  -- INFO: highlight comments like
  -- TODO: fix this
  ["folke/todo-comments.nvim"] = {
    config = require("config.plugins.configs.todo").init,
    dependencies = "telescope.nvim",
    event = "VeryLazy",
  },
  -- INFO:  surround () motion
  ["ur4ltz/surround.nvim"] = {
    config = function()
      require("surround").setup({ mappings_style = "surround" })
    end,
  },
}

return M
