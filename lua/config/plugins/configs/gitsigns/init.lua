local M = {}

function M.init()
  local present, gitsigns = pcall(require, "gitsigns")
  if not present then
    return
  end

  local signs = {
    add = {
      text = "│",
    },
    change = {
      text = "│",
    },
    delete = {
      text = "│",
    },
    topdelete = {
      text = "‾",
    },
    changedelete = {
      text = "~",
    },
    untracked = {
      text = "│",
    },
  }

  gitsigns.setup({
    signs = signs,
    numhl = true,
    linehl = false,
    on_attach = function()
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        vim.keymap.set(mode, l, r, opts)
      end
      map("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Next Hunk" })

      map("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Prev Hunk" })

      map("n", "<Leader>hs", gs.stage_hunk, { desc = "Stage" })
      map("n", "<Leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage" })
      map("n", "<Leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
      map("n", "<Leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
      map("n", "<Leader>hb", gs.blame_line, { desc = "Blame" })
      map("n", "<Leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
      map("n", "<Leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })
      map("n", "<Leader>hP", gs.preview_hunk, { desc = "Preview Hunk" })
      map("n", "<Leader>hs", gs.select_hunk, { desc = "Select Hunk" })
      map("n", "<Leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage" })
      map("n", "<Leader>hR", gs.reset_hunk, { desc = "Reset Hunk" })
      map("n", "<Leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
      map("n", "<Leader>hb", gs.blame_line, { desc = "Blame" })
      map("n", "<Leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
      map("n", "<Leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })
      map("n", "<Leader>hP", gs.preview_hunk, { desc = "Preview Hunk" })
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end)
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end)
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, { desc = "Diffthis" })
    end,
    watch_gitdir = {
      interval = 100,
    },
    current_line_blame = true,
    sign_priority = 5,
    update_debounce = 100,
    status_formatter = nil, -- Use default
  })
end

return M
