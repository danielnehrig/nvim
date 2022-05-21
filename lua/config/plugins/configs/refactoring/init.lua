local M = {}

function M.init()
  local present, refactor = pcall(require, "refactoring")
  if not present then
    return
  end
  refactor.setup({})
end

return M
