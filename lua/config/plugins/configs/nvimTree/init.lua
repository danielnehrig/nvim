local M = {}

function M.init()
  local present, nvimtree = pcall(require, "nvim-tree")
  if not present then
    vim.notify(string.format("nvim-tree not installed"))
    return
  end

  nvimtree.setup({})
  local nvim_tree_events = require("nvim-tree.events")
  local bufferline_state = require("bufferline.api")

  nvim_tree_events.on_tree_open(function()
    bufferline_state.set_offset(31, "File Tree")
  end)

  nvim_tree_events.on_tree_close(function()
    bufferline_state.set_offset(0)
  end)
end

return M
