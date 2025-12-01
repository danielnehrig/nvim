local lsp = require("config.plugins.configs.lspconfig")

vim.lsp.config("gopls", {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    lsp.on_attach(client, bufnr)
  end,
})
