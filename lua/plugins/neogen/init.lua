local remap = require("utils").map_global

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
    remap(
      "n",
      "<Leader>nf",
      ":lua require('neogen').generate({ type = 'func' })<CR>"
    )
    remap(
      "n",
      "<Leader>nc",
      ":lua require('neogen').generate({ type = 'class' })<CR>"
    )
    remap(
      "n",
      "<Leader>nt",
      ":lua require('neogen').generate({ type = 'type' })<CR>"
    )
  end
end

return M
