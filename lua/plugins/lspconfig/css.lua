local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")
local capabilities = require("plugins.lspconfig.capabilities").capabilities

lspconfig.cssls.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
