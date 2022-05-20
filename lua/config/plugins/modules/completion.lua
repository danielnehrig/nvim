local M = {}
M.completion = {
  ["hrsh7th/nvim-cmp"] = {
    config = require("config.plugins.configs.cmp").init,
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
  },
  ["hrsh7th/cmp-nvim-lsp-signature-help"] = {},
  ["onsails/lspkind-nvim"] = {
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
