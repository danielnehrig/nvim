local M = {}

M.init = function()
  local present, better = pcall(require, "better_escape")
  if not present then
    return
  end
  better.setup()
end
return M
