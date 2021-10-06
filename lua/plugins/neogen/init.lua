local remap = require("utils").map_global

local M = {}

M.init = function()
  require("neogen").setup({
    enabled = true,
  })

  vim.cmd([[silent! command DocGen lua require('neogen').generate()]])
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

return M
