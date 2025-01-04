---@module 'lazy.types'

---@class git
---@field git table<string, LazyPluginSpec>
local M = {}

M.git = {
  --- INFO: show git hunks and gutter
  ["lewis6991/gitsigns.nvim"] = {
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame = true,
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  ["gitsigns.nvim"] = {
    opts = function()
      Snacks.toggle({
        name = "Git Signs",
        get = function()
          return require("gitsigns.config").config.signcolumn
        end,
        set = function(state)
          require("gitsigns").toggle_signs(state)
        end,
      }):map("<leader>uG")
    end,
  },
  --- INFO: scrollbar and gutter/diagnostic display
  ["lewis6991/satellite.nvim"] = {
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("satellite").setup()
    end,
  },
  --- INFO: old vim git integration
  ["tpope/vim-fugitive"] = {
    cmd = { "Git", "Git mergetool" },
  },
  --- INFO: lazygit needs lazygit in path
  ["kdheepak/lazygit.nvim"] = { cmd = { "LazyGit" } },
  --- INFO: neogit
  ["NeogitOrg/neogit"] = {
    cmd = { "Neogit" },
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        disable_signs = false,
        disable_hint = false,
      })
    end,
    dependencies = "nvim-lua/plenary.nvim",
  },
  --- INFO: get a link to current file/line on remote
  ["ruifm/gitlinker.nvim"] = {
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
  },
  --- INFO: visual git show buffer history etc
  ["tanvirtin/vgit.nvim"] = {
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "VGit" },
    config = function()
      require("vgit").setup({
        settings = {
          live_gutter = {
            enabled = false,
          },
        },
      })
    end,
  },
  --- INFO: Show git conflicts
  ["akinsho/git-conflict.nvim"] = {
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {},
  },
}
return M
