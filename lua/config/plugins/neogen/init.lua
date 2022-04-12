local set = vim.keymap.set

local M = {}

M.init = function()
  local neogen = require("neogen")
  neogen.setup({})

  vim.cmd([[silent! command DocGen lua require('neogen').generate()]])
  if vim.version().minor >= 7 then
    vim.keymap.set({ "n" }, "<leader>nf", function()
      neogen.generate({ type = "func" })
    end)
  else
    set(
      "n",
      "<Leader>nf",
      ":lua require('neogen').generate({ type = 'func' })<CR>"
    )
    set(
      "n",
      "<Leader>nc",
      ":lua require('neogen').generate({ type = 'class' })<CR>"
    )
    set(
      "n",
      "<Leader>nt",
      ":lua require('neogen').generate({ type = 'type' })<CR>"
    )
  end
end

return M
