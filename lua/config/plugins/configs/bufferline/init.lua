local opt = { silent = true }
local g = vim.g
local M = {}

function M.init()
  require("barbar").setup({
    icons = {
      separator_at_end = false,
      filetype = {
        -- Sets the icon's highlight group.
        -- If false, will use nvim-web-devicons colors
        custom_colors = false,

        -- Requires `nvim-web-devicons` if `true`
        enabled = true,
      },
    },
    exclude_ft = { "quickfix", "terminal", "dap-repl", "repl", "qf", "" },
  })

  g.mapleader = " "
  -- tabnew and tabprev
  vim.api.nvim_set_keymap("n", "<Leader>tp", [[<Cmd>BufferPrevious<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>tn", [[<Cmd>BufferNext<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>t1", [[<Cmd>BufferGoto 1<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>t2", [[<Cmd>BufferGoto 2<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>t3", [[<Cmd>BufferGoto 3<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>t4", [[<Cmd>BufferGoto 4<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>t5", [[<Cmd>BufferGoto 5<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>t6", [[<Cmd>BufferGoto 6<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>t6", [[<Cmd>BufferGoto 6<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>tc", [[<Cmd>BufferClose<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>tt", [[<Cmd>BufferPick<CR>]], opt)
  vim.api.nvim_set_keymap(
    "n",
    "<Leader>ta",
    [[<Cmd>BufferCloseAllButCurrent<CR>]],
    opt
  )
end

return M
