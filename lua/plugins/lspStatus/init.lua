local lsp_status = require("lsp-status")
local LSP = {}

-- snippets setup
-- https://github.com/hrsh7th/nvim-compe#how-to-use-lsp-snippet
LSP.capabilities = vim.lsp.protocol.make_client_capabilities()
LSP.capabilities = vim.tbl_extend(
  "keep",
  LSP.capabilities or {},
  lsp_status.capabilities
)
LSP.capabilities = require("cmp_nvim_lsp").update_capabilities(LSP.capabilities)
LSP.capabilities.textDocument.completion.completionItem.snippetSupport = true
LSP.capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}
LSP.lsp_status = lsp_status

local init = false
if not init then
  LSP.lsp_status.config({
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
  LSP.lsp_status.register_progress()
  init = true
end

return LSP
