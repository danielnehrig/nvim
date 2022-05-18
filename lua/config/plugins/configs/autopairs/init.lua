local M = {}

function M.init()
  local present, npairs = pcall(require, "nvim-autopairs")
  if not present then
    vim.notify("present not installed")
    return
  end
  npairs.setup()
end

return M
