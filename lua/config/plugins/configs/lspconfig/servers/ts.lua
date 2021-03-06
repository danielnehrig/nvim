local lsp = require("config.plugins.configs.lspconfig")
local capabilities =
  require("config.plugins.configs.lspconfig.capabilities").capabilities
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
    client.resolved_capabilities.document_formatting = false

    lsp.on_attach(client, bufnr)
  end,
})
