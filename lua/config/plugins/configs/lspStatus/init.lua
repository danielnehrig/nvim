local LSP = require("config.plugins.configs.lspconfig.capabilities")
local M = {}

-- init lsp-status
function M.init()
  local present, lsp_status = pcall(require, "lsp-status")
  if not present then
    vim.notify("lsp-status not installed")
    return
  end

  LSP.capabilities =
    vim.tbl_extend("keep", LSP.capabilities or {}, lsp_status.capabilities)

  lsp_status.register_progress()

  return lsp_status
end

return M
