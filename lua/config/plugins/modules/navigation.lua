local M = {}

M.packer = {
  ["andymass/vim-matchup"] = {
    setup = function()
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  ["hkupty/nvimux"] = {
    keys = { "<C-a>" },
    config = require("config.plugins.configs.nvimux").init,
  },
  ["nvim-telescope/telescope.nvim"] = {
    -- cmd = { "Telescope" },
    config = require("config.plugins.configs.telescope").init,
    requires = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-project.nvim" },
    },
  },
  ["kyazdani42/nvim-tree.lua"] = {
    requires = "kyazdani42/nvim-web-devicons",
    config = require("config.plugins.configs.nvimTree").init,
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
  },
  ["abecodes/tabout.nvim"] = {
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
  },
}

return M
