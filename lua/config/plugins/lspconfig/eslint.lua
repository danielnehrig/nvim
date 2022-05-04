local lspconfig = require("lspconfig")
local lsp = require("config.plugins.lspconfig")
local capabilities =
  require("config.plugins.lspconfig.capabilities").capabilities

lspconfig.eslint.setup({
  capabilities = capabilities,
  flags = { debounce_text_changes = 500 },
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    lsp.on_attach(client, bufnr)
  end,
})
