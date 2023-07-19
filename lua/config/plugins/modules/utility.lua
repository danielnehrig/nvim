---@module 'config.plugins.modules.types'

---@class utility
---@field utility table<string, PluginInterfaceMerged>
local M = {}
M.utility = {
  ["folke/noice.nvim"] = {
    event = "VimEnter",
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
  ["williamboman/mason.nvim"] = {
    config = function()
      require("mason").setup()
    end,
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
  },
  ["MunifTanjim/nui.nvim"] = { lazy = true },
  ["nvim-lua/plenary.nvim"] = { lazy = true },
  ["https://github.com/andythigpen/nvim-coverage"] = {
    dependencies = "nvim-lua/plenary.nvim",
    lazy = true,
    config = function()
      require("coverage").setup()
    end,
  },
  ["windwp/nvim-autopairs"] = {
    after = "nvim-cmp",
    dependencies = "nvim-cmp",
    config = function()
      require("config.plugins.configs.autopairs").init()
    end,
  },
  ["vimwiki/vimwiki"] = {
    cmd = { "VimwikiIndex", "VimwikiDiaryIndex", "VimwikiMakeDiaryNote" },
  },
  ["folke/which-key.nvim"] = {
    config = function()
      require("config.plugins.configs.which").init()
    end,
  },
  ["max397574/better-escape.nvim"] = {
    event = "InsertCharPre",
    config = function()
      require("config.plugins.configs.betterescape").init()
    end,
  },
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
  ["lambdalisue/suda.vim"] = { cmd = { "SudaWrite" } }, -- save as root
  ["junegunn/vim-slash"] = { keys = { "/" } }, -- better search
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
  ["kevinhwang91/nvim-bqf"] = { ft = "qf" }, -- better quickfix
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
  ["ggandor/lightspeed.nvim"] = {},
  ["jghauser/mkdir.nvim"] = {
    config = function()
      require("mkdir")
    end,
  }, -- create folders if not existing
  ["folke/todo-comments.nvim"] = {
    config = require("config.plugins.configs.todo").init,
    dependencies = "telescope.nvim",
    cmd = { "TodoQuickFix", "TodoTrouble", "TodoTelescope" },
  }, -- show todos in qf
  ["ur4ltz/surround.nvim"] = {
    config = function()
      require("surround").setup({ mappings_style = "surround" })
    end,
  },
}

return M
