local lspconfig = require("lspconfig")
local lsp = require("config.plugins.lspconfig")
local capabilities = require("config.plugins.lspconfig.capabilities").capabilities

lspconfig.cssls.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    lsp.on_attach(client, bufnr)
  end,
})
