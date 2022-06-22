local M = {}
M.completion = {
  ["zbirenbaum/copilot.lua"] = {
    event = { "VimEnter" },
    disable = true,
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()
      end, 100)
    end,
  },
  ["github/copilot.vim"] = {},
  ["rafamadriz/friendly-snippets"] = {
    module = "cmp_nvim_lsp",
    event = "InsertEnter",
  },
  ["hrsh7th/nvim-cmp"] = {
    config = require("config.plugins.configs.cmp").init,
  },
  ["zbirenbaum/copilot-cmp"] = {
    module = "copilot_cmp",
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
    wants = "nvim-cmp",
  },
  ["L3MON4D3/LuaSnip"] = {
    wants = "friendly-snippets",
    config = function()
      require("config.plugins.configs.cmp.luasnip").init()
    end,
    after = "nvim-cmp",
  },
  ["saadparwaiz1/cmp_luasnip"] = {
    after = "LuaSnip",
  },
  ["f3fora/cmp-spell"] = {
    after = "cmp_luasnip",
  },
  ["hrsh7th/cmp-path"] = {
    after = "cmp-spell",
  },
  ["hrsh7th/cmp-nvim-lsp"] = {},
  ["hrsh7th/cmp-buffer"] = {
    after = "cmp-nvim-lsp",
  },
  ["hrsh7th/cmp-cmdline"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-nvim-lsp-signature-help"] = {
    after = "cmp-cmdline",
  },
  ["onsails/lspkind-nvim"] = {
    wants = "nvim-cmp",
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
