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

  lsp_status.config({
    select_symbol = function(cursor_pos, symbol)
      if symbol.valueRange then
        local value_range = {
          ["start"] = {
            character = 0,
            line = vim.fn.byte2line(symbol.valueRange[1]),
          },
          ["end"] = {
            character = 0,
            line = vim.fn.byte2line(symbol.valueRange[2]),
          },
        }

        return require("lsp-status.util").in_range(cursor_pos, value_range)
      end
    end,
  })
  lsp_status.register_progress()

  return lsp_status
end

return M
