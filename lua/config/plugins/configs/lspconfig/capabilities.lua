local LSP = {}

-- snippets setup
-- https://github.com/hrsh7th/nvim-compe#how-to-use-lsp-snippet
LSP.capabilities = vim.lsp.protocol.make_client_capabilities()
LSP.capabilities.textDocument.completion.completionItem.snippetSupport = true
LSP.capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}
LSP.capabilities =
  require("cmp_nvim_lsp").default_capabilities(LSP.capabilities)
LSP.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

return LSP
