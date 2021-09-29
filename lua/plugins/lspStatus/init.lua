local lsp_status = require("lsp-status")
local LSP = require("plugins.lspconfig.capabilities")
local M = {}

-- the inited instance of lsp-status for usage in statusline
M.lsp_status = lsp_status

-- init lsp-status
function M.init()
  LSP.capabilities = vim.tbl_extend(
    "keep",
    LSP.capabilities or {},
    lsp_status.capabilities
  )

  M.lsp_status.config({
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
  M.lsp_status.register_progress()
end

return M
