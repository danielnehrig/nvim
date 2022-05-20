local lspconfig = require("lspconfig")
local lsp = require("config.plugins.configs.lspconfig")

lspconfig.gopls.setup({
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    lsp.on_attach(client, bufnr)
  end,
})
