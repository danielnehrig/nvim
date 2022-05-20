local M = {}

M.init = function()
  local present, which = pcall(require, "which-key")

  if not present then
    return
  end

  which.setup({})
end

return M
