local lsp = require("config.plugins.lspconfig")
local capabilities =
  require("config.plugins.lspconfig.capabilities").capabilities
local lspconfig = require("lspconfig")

lspconfig.tsserver.setup({
  filetypes = {
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
  },
  capabilities = capabilities,
  flags = { debounce_text_changes = 500 },
  on_attach = function(client, bufnr)
    -- disable TS formatting since we use efm
    client.server_capabilities.documentFormattingProvider = false

    lsp.on_attach(client, bufnr)
  end,
})
