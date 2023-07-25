---@module 'lazy.types'

---@class completion
---@field completion table<string, LazyPluginSpec>
local M = {}
M.completion = {
  ["github/copilot.vim"] = {},
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
    },
  },
  ["danielnehrig/nvim-cmp-lua-latex-symbols"] = {
    dependencies = "hrsh7th/nvim-cmp",
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
    config = function()
      require("config.plugins.configs.cmp.luasnip").init()
    end,
  },
  ["onsails/lspkind-nvim"] = {
    dependencies = "hrsh7th/nvim-cmp",
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
