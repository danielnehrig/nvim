local config = require("config.core.config").config
print(config.ai_options.openai_key)
---@module 'lazy.types'

---@class completion
---@field completion table<string, LazyPluginSpec>
local M = {}
M.completion = {
  -- TODO: manage config of this by user cfg
  ["jackMort/ChatGPT.nvim"] = {
    event = "VeryLazy",
    enabled = function()
      if config.ai_options.openai_key == "" then
        return false
      end
      if config.ai_options.openai_key == nil then
        return false
      end

      return true
    end,
    opts = {
      api_key_cmd = config.ai_options.openai_key,
      openai_params = {
        model = "gpt-4-1106-preview",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 4095,
        temperature = 0.2,
        top_p = 0.1,
        n = 1,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  --- INFO: ai powered completion github
  ["github/copilot.vim"] = {
    event = "VeryLazy",
  },
  --- INFO: completion plugin
  ["hrsh7th/nvim-cmp"] = {
    config = require("config.plugins.configs.cmp").init,
    event = "InsertEnter",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "danielnehrig/nvim-cmp-lua-latex-symbols",
    },
  },
  ["kristijanhusak/orgmode.nvim"] = {
    config = function()
      require("orgmode").setup({
        org_agenda_files = { "~/org/*" },
        org_default_notes_file = "~/org/refile.org",
      })
      require("orgmode").setup_ts_grammar()
    end,
    keys = { "<space>oc", "<space>oa" },
    ft = { "org" },
    dependencies = "nvim-cmp",
  },
  ["L3MON4D3/LuaSnip"] = {
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "2.*",
    build = "make install_jsregexp",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      require("config.plugins.configs.cmp.luasnip").init()
    end,
  },
  ["onsails/lspkind-nvim"] = {
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      require("lspkind").init({
        mode = "symbol_text",
        preset = "codicons",
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
  },
}
return M
