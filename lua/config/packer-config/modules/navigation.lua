local M = {}

M.packer = {
  {
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
  },
  {
    "hkupty/nvimux",
    keys = { "<C-a>" },
    config = require("config.plugins.nvimux").init,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    config = require("config.plugins.telescope").init,
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
  {
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = require("config.plugins.nvimTree").init,
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
  },
  {
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
  },
}

return M
