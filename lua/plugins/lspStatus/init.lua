local lsp_status = require("lsp-status")
local LSP = {}

-- snippets setup
-- https://github.com/hrsh7th/nvim-compe#how-to-use-lsp-snippet
LSP.capabilities = vim.lsp.protocol.make_client_capabilities()
LSP.capabilities = vim.tbl_extend("keep", LSP.capabilities or {}, require("lsp-status").capabilities)
LSP.capabilities.textDocument.completion.completionItem.snippetSupport = true
LSP.capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits"
    }
}

lsp_status.register_progress()

return LSP
