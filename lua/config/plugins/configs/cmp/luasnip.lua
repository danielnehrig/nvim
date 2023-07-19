local M = {}

function M.init()
  local present, ls = pcall(require, "luasnip")
  if not present then
    return
  end

  require("luasnip.loaders.from_vscode").lazy_load()
end

return M
