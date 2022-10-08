local lspconfig = require("lspconfig")
local lsp = require("config.plugins.configs.lspconfig")

lspconfig.gopls.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    lsp.on_attach(client, bufnr)
  end,
})
