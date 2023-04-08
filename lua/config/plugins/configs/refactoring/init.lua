local M = {}

function M.init()
  local present, refactor = pcall(require, "refactoring")
  if not present then
    return
  end
  refactor.setup({})
  local t_present, telescope = pcall(require, "telescope")
  if not t_present then
    return
  end
  telescope.load_extension("refactoring")
end

return M
